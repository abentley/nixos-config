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

      fileSystems."/mnt/ubuntu" = {
        device = "/dev/disk/by-uuid/9e3f835c-90bc-46e8-ade1-508931d94def";
        fsType = "ext4";
      };

      fileSystems."/home/abentley" = {
        device = "/mnt/ubuntu/home/abentley";
        options = [ "bind" ];
      };

      fileSystems."/home/abentley/.config" = {
        device = "/home/abentley/.nixos-config";
        options = [ "bind" ];
      };

      # Enable features
      myFeatures = {
        grub = {
          bootMode = "efi";
          resolution = "1280x720x32";
          splashImage = pkgs.fetchurl {
            url = "https://assets.aaronbentley.com/treemoon-3.png";
            sha256 = "4d7b02f8e950f8bf5e9b45cf993d8307ad3778980d131e1d8d4cf09aa9fdfd16";
          };
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
    ../suites/audio-production.nix
    ../suites/graphical-computer.nix
    ../features/options.nix
    home-manager.nixosModules.home-manager
    custom
  ];
}
