#!/bin/sh
set -eux
for instance in hp handy gamey-wsl thinky teeny skinny lappy; do
    nixos-rebuild dry-build --flake .#${instance}
done
