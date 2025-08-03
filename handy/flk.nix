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
    ./hardware-configuration.nix
    ./specific.nix
    ../features/auto-rotation.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../suites/audio-production.nix
    ../features/hyprland.nix
    ../features/flake-enablement.nix
    ../features/early-console.nix
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.abentley = ../users/abentley.nix;
        users.root = ../users/root.nix;
        backupFileExtension = "backup";
      };
    }
  ];
  specialArgs = {
    primaryUser = "abentley";
    consoleFontName = "terminus";
  };
}
