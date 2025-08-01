{
  self,
  nixpkgs,
  home-manager,
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ../auto-rotation.nix
    ../base.nix
    ../graphical.nix
    ../audio.nix
    ../hyprland.nix
    ../flake-enablement.nix
    ../early-console.nix
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.abentley = ../abentley.nix;
        users.root = ../root.nix;
        backupFileExtension = "backup";
      };
    }
  ];
  specialArgs = {
    primaryUser = "abentley";
    consoleFontName = "terminus";
  };
}
