{ config, pkgs, ... }:

{
  imports = [ ./graphical-computer.nix ];

  services.power-profiles-daemon.enable = true;
}
