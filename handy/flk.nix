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
    ../features/auto-rotation.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../suites/audio-production.nix
    ../features/grub.nix
    ../features/hyprland.nix
    ../features/flake-enablement.nix
    ../features/early-console.nix
    ../features/steam.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
    custom
  ];
  specialArgs = {
    primaryUser = "abentley";
    consoleFontName = "terminus";
  };
}
