{
  self,
  nixpkgs,
  home-manager,
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    # Include the results of the hardware scan.
    ./configuration.nix
    ../suites/graphical.nix
    ../suites/base.nix
    # Not supported on integrated graphics of this machine
    # ../hyprland.nix
    #../flake-enablement.nix
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
  };
}
