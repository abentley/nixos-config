#!/usr/bin/env bash
set -euo pipefail

SOCKET_DIR="${XDG_RUNTIME_DIR:-/tmp}/nvim-server-${UID}"

target_socket=""
target_tab_id=""
target_pane_id=""
target_session=""

in_zellij=false
if [ -n "${ZELLIJ:-}" ] || [ -n "${ZELLIJ_SESSION_NAME:-}" ]; then
  in_zellij=true
fi

if [ "$in_zellij" = true ]; then
  session_name="${ZELLIJ_SESSION_NAME:-default}"
  session_safe=$(printf '%s' "$session_name" | tr -c 'a-zA-Z0-9_-' '_')

  pane_id="${ZELLIJ_PANE_ID:-}"
  pane_num="${pane_id#terminal_}"
  current_tab_id=""

  if [ -n "$pane_num" ]; then
    panes_json=$(zellij action list-panes --json 2>/dev/null || true)
    if [ -n "$panes_json" ]; then
      if command -v jq >/dev/null 2>&1; then
        current_tab_id=$(printf '%s\n' "$panes_json" | jq -r --argjson pid "$pane_num" '.[] | select(.id == $pid and .is_plugin == false) | .tab_id' 2>/dev/null || true)
      elif command -v python3 >/dev/null 2>&1; then
        current_tab_id=$(printf '%s\n' "$panes_json" | python3 -c "import sys, json; data=json.load(sys.stdin); print(next((p.get('tab_id') for p in data if not p.get('is_plugin') and p.get('id')==$pane_num), ''))" 2>/dev/null || true)
      fi
    fi
  fi

  if [ -z "$current_tab_id" ] || [ "$current_tab_id" = "null" ]; then
    if command -v jq >/dev/null 2>&1; then
      current_tab_id=$(zellij action current-tab-info --json 2>/dev/null | jq -r '.tab_id // empty' 2>/dev/null || true)
    elif command -v python3 >/dev/null 2>&1; then
      current_tab_id=$(zellij action current-tab-info --json 2>/dev/null | python3 -c "import sys, json; print(json.load(sys.stdin).get('tab_id', ''))" 2>/dev/null || true)
    fi
  fi

  # Look for nvim-server in the current tab
  if [ -n "$current_tab_id" ]; then
    tab_safe=$(printf '%s' "$current_tab_id" | tr -c 'a-zA-Z0-9_-' '_')
    candidate_socket="$SOCKET_DIR/zellij_${session_safe}_tab_${tab_safe}.sock"
    candidate_meta="$SOCKET_DIR/zellij_${session_safe}_tab_${tab_safe}.info"

    if [ -S "$candidate_socket" ] && nvim --headless --server "$candidate_socket" --remote-expr '1' >/dev/null 2>&1; then
      target_socket="$candidate_socket"
      target_tab_id="$current_tab_id"
      target_session="$session_name"
      if [ -f "$candidate_meta" ]; then
        target_pane_id=$(sed -n 's/^PANE_ID=//p' "$candidate_meta")
      fi
    fi
  fi

  if [ -z "$target_socket" ]; then
    echo "nvim-open: no nvim-server running in current tab" >&2
    exit 1
  fi
else
  # Outside Zellij: check NVIM_SERVER_SOCKET or default socket
  if [ -n "${NVIM_SERVER_SOCKET:-}" ] && [ -S "$NVIM_SERVER_SOCKET" ]; then
    if nvim --headless --server "$NVIM_SERVER_SOCKET" --remote-expr '1' >/dev/null 2>&1; then
      target_socket="$NVIM_SERVER_SOCKET"
    fi
  elif [ -S "$SOCKET_DIR/default.sock" ]; then
    if nvim --headless --server "$SOCKET_DIR/default.sock" --remote-expr '1' >/dev/null 2>&1; then
      target_socket="$SOCKET_DIR/default.sock"
    fi
  fi

  if [ -z "$target_socket" ]; then
    echo "nvim-open: no running nvim-server found" >&2
    exit 1
  fi
fi

tab_mode=false
files=()
plus_cmd=""

while [ $# -gt 0 ]; do
  case "$1" in
    -t|--tab)
      tab_mode=true
      shift
      ;;
    +*)
      plus_cmd="$1"
      shift
      ;;
    --)
      shift
      while [ $# -gt 0 ]; do
        files+=("$(realpath -m "$1")")
        shift
      done
      break
      ;;
    *)
      files+=("$(realpath -m "$1")")
      shift
      ;;
  esac
done

if [ ${#files[@]} -gt 0 ]; then
  if [ -n "$plus_cmd" ] && [ ${#files[@]} -eq 1 ]; then
    nvim --headless --server "$target_socket" --remote-send "<C-\\><C-N>:e ${plus_cmd} ${files[0]}<CR>" >/dev/null 2>&1 || true
  elif [ "$tab_mode" = true ]; then
    nvim --headless --server "$target_socket" --remote-tab "${files[@]}" >/dev/null 2>&1 || true
  else
    nvim --headless --server "$target_socket" --remote "${files[@]}" >/dev/null 2>&1 || true
  fi
fi

# Focus tab and pane
if [ -n "$target_tab_id" ]; then
  if [ -n "${target_session:-}" ]; then
    zellij --session "$target_session" action go-to-tab-by-id "$target_tab_id" 2>/dev/null || true
    if [ -n "$target_pane_id" ]; then
      zellij --session "$target_session" action focus-pane-id "$target_pane_id" 2>/dev/null || true
    fi
  else
    zellij action go-to-tab-by-id "$target_tab_id" 2>/dev/null || true
    if [ -n "$target_pane_id" ]; then
      zellij action focus-pane-id "$target_pane_id" 2>/dev/null || true
    fi
  fi
fi
