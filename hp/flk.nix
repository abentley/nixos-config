# Provide a NixOS system configuration for the hp machine.
{
  self,
  nixpkgs,
  home-manager,
  ...
}:
let
  custom = (
    { config, pkgs, ... }:
    {
      # Bootloader.
      boot.loader.grub.device = "/dev/sda";
      networking.hostName = "hp"; # Define your hostname.
    }
  );
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../base-configuration.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../suites/graphical-computer.nix
    ../suites/base.nix
    # Not supported on integrated graphics of this machine
    # ../hyprland.nix
    ../features/flake-enablement.nix
    ../features/grub.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
    custom
  ];
  specialArgs = {
    primaryUser = "abentley";
  };
}
