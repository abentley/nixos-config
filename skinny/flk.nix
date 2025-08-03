{
  self,
  nixpkgs,
  home-manager,
  ...
}:
let
  custom = ({
    # Bootloader.
    boot.loader.systemd-boot = {
      enable = true;
      consoleMode = "0";
    };
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "skinny"; # Define your hostname.

    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

  });
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../base-configuration.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../features/hyprland.nix
    ../features/flake-enablement.nix
    ../features/early-console.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
    custom
  ];
  specialArgs = {
    primaryUser = "abentley";
    consoleFontName = "terminus";
  };
}
