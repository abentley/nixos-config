{ config, pkgs, ... }:

{
  imports = [
    ./graphical-computer.nix
    ../features/battery-notifier.nix
  ];

  environment.systemPackages = [
    pkgs.powertop
  ];
  features.battery-notifier.enable = true;
  services.power-profiles-daemon.enable = true;
  # Enables hardware-level power tuning at boot (PCI, Audio, USB, VM writeback)
  powerManagement.powertop.enable = true;
}
