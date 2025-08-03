{
  self,
  nixpkgs,
  home-manager,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../base-configuration.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./specific.nix
    ../suites/graphical-computer.nix
    ../suites/base.nix
    # Not supported on integrated graphics of this machine
    # ../hyprland.nix
    ../features/flake-enablement.nix
    ../features/grub.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
  ];
  specialArgs = {
    primaryUser = "abentley";
  };
}
