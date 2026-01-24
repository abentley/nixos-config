#!/bin/sh
set -e

# A script to verify that NixOS refactoring doesn't change the output derivation.
# By default, it compares all known hosts. A specific host can be targeted.
# The --update flag saves the new build as the baseline instead of comparing.

ALL_HOSTS="hp handy gamey gamey-wsl thinky thinky-wsl skinny lappy portable teeny"

usage() {
    echo "Usage: $0 [--update] [<hostname>...]"
    echo "  (no hostname): (Default) Compares all known hosts against their baselines."
    echo "  <hostname>...: Compares one or more specific hosts against their baselines."
    echo "  --update:      Saves the build output as the new baseline instead of comparing."
    echo
    echo "Known hostnames: $ALL_HOSTS"
    exit 1
}

# --- Argument Parsing ---
CMD="compare"
TARGET_HOSTS="" # Space-separated list of hosts from args

while [ "$#" -gt 0 ]; do
    case "$1" in
        --update)
            CMD="save"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            # Append any other argument to the list of target hosts
            TARGET_HOSTS="$TARGET_HOSTS $1"
            shift
            ;;
    esac
done

# Trim leading/trailing whitespace
TARGET_HOSTS=$(echo "$TARGET_HOSTS" | awk '{$1=$1};1')

# --- Determine Hosts to Process ---
HOSTS_TO_PROCESS=""
if [ -n "$TARGET_HOSTS" ]; then
    HOSTS_TO_PROCESS="$TARGET_HOSTS"
else
    HOSTS_TO_PROCESS="$ALL_HOSTS"
fi

# --- Main Processing Loop ---
BASELINE_DIR="./.baselines"
mkdir -p "$BASELINE_DIR"

# Use the modern `nix build` command which correctly handles flake URIs.
build_and_get_path() {
    local flake_attr=$1
    echo "Building $flake_attr..." >&2
    nix --extra-experimental-features 'nix-command flakes' build "$flake_attr" --no-link --print-out-paths
}

for HOST in $HOSTS_TO_PROCESS; do
    echo
    echo "--- Processing host: $HOST ---"

    FLAKE_ATTR=".#nixosConfigurations.$HOST.config.system.build.toplevel"
    BASELINE_PATH_FILE="$BASELINE_DIR/$HOST.path"

    case "$CMD" in
        save)
            RESULT_PATH=$(build_and_get_path "$FLAKE_ATTR")
            echo "Saving baseline path to $BASELINE_PATH_FILE"
            echo "$RESULT_PATH" > "$BASELINE_PATH_FILE"
            echo "Baseline updated: $RESULT_PATH"
            ;;
        compare)
            if [ ! -f "$BASELINE_PATH_FILE" ]; then
                echo "Error: Baseline path file not found for '$HOST'." >&2
                echo "Run '$0 --update $HOST' first to create a baseline." >&2
                continue # Skip to the next host
            fi

            BASELINE_PATH=$(cat "$BASELINE_PATH_FILE")
            CURRENT_PATH=$(build_and_get_path "$FLAKE_ATTR")

            echo
            echo "Baseline path: $BASELINE_PATH"
            echo "Current path:  $CURRENT_PATH"
            echo

            if [ "$BASELINE_PATH" = "$CURRENT_PATH" ]; then
                echo "✅ Outputs are identical for $HOST."
            else
                echo "❌ Outputs differ for $HOST. Showing differences with nix-diff..."
                echo
                if ! command -v nix-diff &> /dev/null; then
                    echo "Warning: 'nix-diff' not found. Please install it to see the differences." >&2
                    echo "You can typically install it with: nix-env -iA nixpkgs.nix-diff" >&2
                else
                    nix-diff --color=always "$BASELINE_PATH" "$CURRENT_PATH" | less -R
                fi
            fi
            ;;
    esac
done

echo
echo "--- All hosts processed. ---"
