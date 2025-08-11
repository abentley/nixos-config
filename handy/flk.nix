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
        loader.systemd-boot.consoleMode = "auto";
      };
      networking.hostName = "handy"; # Define your hostname.
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
    ../features/hyprland.nix
    ../features/flake-enablement.nix
    ../features/early-console.nix
    ../features/steam.nix
    ../features/systemd-boot.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
    custom
  ];
  specialArgs = {
    primaryUser = "abentley";
    consoleFontName = "terminus";
  };
}
