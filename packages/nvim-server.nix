# Provide a Nix package for nvim-server.
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.writeShellApplication {
  name = "nvim-server";
  runtimeInputs = [
    pkgs.neovim
    pkgs.zellij
    pkgs.jq
    pkgs.coreutils
  ];
  text = builtins.readFile ../scripts/nvim-server.sh;
}
