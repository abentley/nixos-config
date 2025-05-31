{ self, nixpkgs, home-manager }:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ../base.nix
    ../graphical.nix
    ../audio.nix
    ../hyprland.nix
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.abentley = ./home.nix;
      home-manager.backupFileExtension = "backup";
    }
  ];
}
