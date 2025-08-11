{
  self,
  nixpkgs,
  home-manager,
  ...
}:
let
  custom = ({
    # Bootloader.
    boot = {
      loader.systemd-boot.consoleMode = "0";
      initrd.kernelModules = [ "i915" ];
    };
    networking.hostName = "skinny"; # Define your hostname.
  });
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../features/systemd-boot.nix
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
