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
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../features/options.nix # Add the new options file
    home-manager.nixosModules.home-manager
    custom
    {
      # Enable features
      myFeatures = {
        grub = {
          bootMode = "bios";
        };
        homeManager.enable = true;
        flakeEnablement.enable = true;
      };
    }
  ];
}
