# Provide a Nix package for nvim-open.
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.writeShellApplication {
  name = "nvim-open";
  runtimeInputs = [
    pkgs.neovim
    pkgs.zellij
    pkgs.jq
    pkgs.coreutils
  ];
  text = builtins.readFile ../scripts/nvim-open.sh;
}
