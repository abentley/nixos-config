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
    ./specific.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../suites/audio-production.nix
    ../features/grub.nix
    ../features/hyprland.nix
    ../features/early-console.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
  ];
  specialArgs = {
    primaryUser = "abentley";
    consoleFontName = "spleen";
  };
}
