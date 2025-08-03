#!/bin/sh
set -eux
for instance in hp handy gamey-wsl thinky teeny hp; do
    nixos-rebuild dry-build --flake .#${instance}
done
