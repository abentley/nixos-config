#!/usr/bin/env bash
set -euo pipefail

SOCKET_DIR="${XDG_RUNTIME_DIR:-/tmp}/nvim-server-${UID}"
mkdir -p "$SOCKET_DIR"
chmod 700 "$SOCKET_DIR"

socket=""
meta=""

in_zellij=false
if [ -n "${ZELLIJ:-}" ] || [ -n "${ZELLIJ_SESSION_NAME:-}" ]; then
  in_zellij=true
fi

if [ "$in_zellij" = true ]; then
  session_name="${ZELLIJ_SESSION_NAME:-default}"
  session_safe=$(printf '%s' "$session_name" | tr -c 'a-zA-Z0-9_-' '_')

  pane_id="${ZELLIJ_PANE_ID:-}"
  pane_num="${pane_id#terminal_}"
  tab_id=""

  if [ -n "$pane_num" ]; then
    panes_json=$(zellij action list-panes --json 2>/dev/null || true)
    if [ -n "$panes_json" ]; then
      if command -v jq >/dev/null 2>&1; then
        tab_id=$(printf '%s\n' "$panes_json" | jq -r --argjson pid "$pane_num" '.[] | select(.id == $pid and .is_plugin == false) | .tab_id' 2>/dev/null || true)
      elif command -v python3 >/dev/null 2>&1; then
        tab_id=$(printf '%s\n' "$panes_json" | python3 -c "import sys, json; data=json.load(sys.stdin); print(next((p.get('tab_id') for p in data if not p.get('is_plugin') and p.get('id')==$pane_num), ''))" 2>/dev/null || true)
      fi
    fi
  fi

  if [ -z "$tab_id" ] || [ "$tab_id" = "null" ]; then
    if command -v jq >/dev/null 2>&1; then
      tab_id=$(zellij action current-tab-info --json 2>/dev/null | jq -r '.tab_id // empty' 2>/dev/null || true)
    elif command -v python3 >/dev/null 2>&1; then
      tab_id=$(zellij action current-tab-info --json 2>/dev/null | python3 -c "import sys, json; print(json.load(sys.stdin).get('tab_id', ''))" 2>/dev/null || true)
    fi
  fi

  if [ -z "$tab_id" ] || [ "$tab_id" = "null" ]; then
    tab_id="0"
  fi

  tab_safe=$(printf '%s' "$tab_id" | tr -c 'a-zA-Z0-9_-' '_')
  socket="$SOCKET_DIR/zellij_${session_safe}_tab_${tab_safe}.sock"
  meta="$SOCKET_DIR/zellij_${session_safe}_tab_${tab_safe}.info"

  if [ -S "$socket" ] || [ -f "$meta" ]; then
    if nvim --headless --server "$socket" --remote-expr '1' >/dev/null 2>&1; then
      echo "nvim-server: A server is already running in this Zellij tab (tab ID: $tab_id)." >&2
      exit 1
    else
      rm -f "$socket" "$meta"
    fi
  fi

  {
    echo "PID=$$"
    echo "PANE_ID=${pane_id}"
    echo "TAB_ID=${tab_id}"
    echo "SESSION=${session_name}"
    echo "SOCKET=${socket}"
  } > "$meta"

else
  if [ -n "${NVIM_SERVER_SOCKET:-}" ]; then
    socket="$NVIM_SERVER_SOCKET"
    meta="$SOCKET_DIR/custom.info"
  else
    socket="$SOCKET_DIR/default.sock"
    meta="$SOCKET_DIR/default.info"
  fi

  if [ -S "$socket" ] || [ -f "$meta" ]; then
    if nvim --headless --server "$socket" --remote-expr '1' >/dev/null 2>&1; then
      echo "nvim-server: A server is already running on $socket." >&2
      exit 1
    else
      rm -f "$socket" "$meta"
    fi
  fi

  {
    echo "PID=$$"
    echo "PANE_ID="
    echo "TAB_ID="
    echo "SESSION="
    echo "SOCKET=${socket}"
  } > "$meta"
fi

cleanup() {
  rm -f "$socket" "$meta"
}
trap cleanup EXIT INT TERM

nvim --listen "$socket" "$@"
