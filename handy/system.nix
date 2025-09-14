# Provide a NixOS system configuration for the handy machine.
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
      networking.hostName = "handy"; # Define your hostname.
    }
  );
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../base-configuration.nix
    ./hardware-configuration.nix
    ../base-configuration.nix
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../suites/audio-production.nix
    home-manager.nixosModules.home-manager
    ../features/options.nix # Add the new options file
    custom
    {
      # Enable features
      myFeatures = {
        autoRotation.enable = true;
        grub = {
          enable = true;
          bootMode = "efi"; # Assuming EFI for handy
          resolution = "1280x720x32";
          splashImage = ../teeny/darktrees.png;
        };
        hyprland = {
          enable = true;
          primaryUser = "abentley";
        };
        flakeEnablement.enable = true;
        earlyConsole = {
          enable = true;
          consoleFontName = "terminus";
        };
        steam.enable = true;
        homeManager.enable = true;
      };
    }
  ];
}
