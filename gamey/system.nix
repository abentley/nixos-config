# Provide a NixOS system configuration for the gamey machine.
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
      networking.hostName = "gamey"; # Define your hostname.
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
    ../features/options.nix
    home-manager.nixosModules.home-manager
    custom
    {
      boot.supportedFilesystems = [ "bcachefs" ];

      # Redefined from hardware so I can supply POLICY
      fileSystems."/" = {
        device = "UUID=0e047d03-9eea-4bde-8244-abc75adf6847";
        fsType = "bcachefs";
        options = [
          "compression=lz4"
          "foreground_target=ssd"
          "background_target=hdd"
          "promote_target=ssd"
        ];
      };

      # Enable features
      myFeatures = {
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
          enable = false;
          consoleFontName = "terminus";
        };
        steam.enable = true;
      };
    }
  ];
}
