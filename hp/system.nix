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
    ../base-configuration.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../suites/graphical-computer.nix
    ../suites/base.nix
    # Not supported on integrated graphics of this machine
    # ../hyprland.nix
    home-manager.nixosModules.home-manager
    ../features/options.nix # Add the new options file
    custom
    {
      # Enable features
      myFeatures = {
        flakeEnablement.enable = true;
        # Bootloader.
        grub = {
          bootMode = "bios";
        };
        homeManager.enable = true;
      };
    }
  ];
}
