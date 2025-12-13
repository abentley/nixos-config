{ config, pkgs, ... }:

{
  imports = [
    ./graphical-computer.nix
    ../features/battery-notifier.nix
  ];

  features.battery-notifier.enable = true;
  services.power-profiles-daemon.enable = true;
}
