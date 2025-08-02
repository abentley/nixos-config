{
  self,
  nixpkgs,
  home-manager,
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./specific.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../suites/audio-production.nix
    ../features/hyprland.nix
    ../features/early-console.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.abentley = ../users/abentley.nix;
      home-manager.users.root = ../users/root.nix;
      home-manager.backupFileExtension = "backup";
    }
  ];
  specialArgs = {
    primaryUser = "abentley";
    consoleFontName = "spleen";
  };
}
