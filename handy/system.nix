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
    ../suites/base.nix
    ../suites/laptop.nix
    ../suites/audio-production.nix
    ../features/options.nix # Add the new options file
    home-manager.nixosModules.home-manager
    custom
    {
      # Enable features
      myFeatures = {
        autoRotation.enable = true;
        grub = {
          bootMode = "efi";
          resolution = "1280x720x32";
          splashImage = ../teeny/darktrees.png;
        };
        homeManager.enable = true;
        hyprland = {
          enable = true;
          primaryUser = "abentley";
        };
        flakeSupport.enable = true;
        earlyConsole = {
          enable = true;
          consoleFontName = "terminus";
        };
        steam.enable = true;
      };
    }
  ];
}
