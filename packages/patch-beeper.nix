# Provide a Nix package for patch-beeper.
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.writeShellApplication {
  name = "patch-beeper";
  runtimeInputs = [ pkgs.poke ];
  text = builtins.readFile ../scripts/patch-beeper.sh;
}
