# Provide a suite of packages for development, including antigravity tools.
antigravity-nix:
{ config, pkgs, ... }:

{
  environment.systemPackages = [
    antigravity-nix.packages.x86_64-linux.default
    antigravity-nix.packages.x86_64-linux.google-antigravity-ide
    antigravity-nix.packages.x86_64-linux.google-antigravity-cli
    hexedit
    xxd
  ];
}
