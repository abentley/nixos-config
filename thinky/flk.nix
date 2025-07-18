{
  self,
  nixpkgs,
  home-manager,
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ../base.nix
    ../graphical.nix
    ../audio.nix
    ../hyprland.nix
    ../flake-enablement.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.abentley = ../abentley.nix;
      home-manager.users.root = ../root.nix;
      home-manager.backupFileExtension = "backup";
    }
  ];
  specialArgs = {
    primaryUser = "abentley";
  };
}
