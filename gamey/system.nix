# Provide a NixOS system configuration for the gamey machine.
{
  self,
  nixpkgs,
  home-manager,
  antigravity-nix,
  ...
}:
let
  custom = (
    { config, pkgs, ... }:
    {
      # Better gaming support
      boot.kernelPackages = pkgs.linuxPackages_zen;
      boot.supportedFilesystems = [ "bcachefs" ];

      # Redefined from hardware so I can supply POLICY
      fileSystems = {
        "/" = {
          device = "UUID=0e047d03-9eea-4bde-8244-abc75adf6847";
          fsType = "bcachefs";
        };

        "/mnt/ubuntu" = {
          device = "/dev/disk/by-uuid/9e3f835c-90bc-46e8-ade1-508931d94def";
          fsType = "ext4";
        };

        "/mnt/exchange" = {
          device = "/dev/disk/by-uuid/1473-340A";
          fsType = "vfat";
          options = [ "uid=1000" ];
        };

        "/home/abentley" = {
          device = "/mnt/ubuntu/home/abentley";
          options = [ "bind" ];
          fsType = "none";
        };

        "/home/abentley/.config" = {
          device = "/home/abentley/.nixos-config";
          options = [ "bind" ];
          fsType = "none";
        };
      };

      # Intel Graphics configuration
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          libvdpau-va-gl
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
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
    ../physical-machine.nix
    ./hardware-configuration.nix
    ./nvidia.nix
    ../suites/base.nix
    ../suites/audio-production.nix
    ../suites/graphical-computer.nix
    (import ../suites/dev.nix antigravity-nix)
    ../features/options.nix
    home-manager.nixosModules.home-manager
    custom
  ];
}
