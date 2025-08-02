{
  self,
  nixpkgs,
  home-manager,
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ../features/auto-rotation.nix
    ../suites/base.nix
    ../suites/graphical.nix
    ../suites/audio.nix
    ../features/hyprland.nix
    #../git/flake-enablement.nix
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
