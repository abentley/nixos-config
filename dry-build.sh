#!/bin/sh
set -eux
for instance in hp handy gamey-wsl thinky teeny skinny; do
    nixos-rebuild dry-build --flake .#${instance}
done
