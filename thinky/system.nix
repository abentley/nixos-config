# Provide a NixOS system configuration for the thinky machine.
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
        loader = {
          grub = {
            device = "nodev";
            efiSupport = true;
            gfxmodeEfi = "1366x768x32";
            # efiInstallAsRemovable = true;
            splashImage = "/home/abentley/treemoon2.png";
            # font = "${pkgs.hack-font}/share/fonts/hack/Hack-Regular.ttf";
            # fontSize = 24;
          };
          efi.canTouchEfiVariables = true;
        };
        initrd.kernelModules = [ "i915" ];
      };

      # boot.loader.systemd-boot.enable = true;
      # Conflicts with boot.loader.grub.efiInstallAsRemovable = true;
      # boot.plymouth.enable = true;

      networking.hostName = "thinky"; # Define your hostname.

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      environment.systemPackages = with pkgs; [
        shotwell
      ];
    }
  );
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../base-configuration.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../suites/audio-production.nix
    ../features/grub.nix
    ../features/home-manager.nix
    ../features/hyprland.nix
    ../features/early-console.nix
    ../features/flake-enablement.nix
    home-manager.nixosModules.home-manager
    custom
  ];
  specialArgs = {
    primaryUser = "abentley";
    consoleFontName = "spleen";
  };
}
