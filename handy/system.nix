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
      # Bootloader.
      boot = {
        initrd.kernelModules = [ "i915" ];
        loader.grub = {
          device = "nodev";
          efiSupport = true;
          splashImage = ../teeny/darktrees.png;
          gfxmodeEfi = "1280x720x32";
        };
        loader.efi.canTouchEfiVariables = true;
      };
      networking.hostName = "handy"; # Define your hostname.
      environment.systemPackages = with pkgs; [
        efibootmgr
      ];
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
        grub.enable = true;
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
