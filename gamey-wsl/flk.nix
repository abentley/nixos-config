{
  self,
  nixpkgs,
  home-manager,
  nixos-wsl,
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ../base.nix
    ../graphical-non-host.nix
    ../flake-enablement.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.abentley = ../abentley.nix;
      home-manager.users.root = ../root.nix;
      home-manager.backupFileExtension = "backup";
    }
    nixos-wsl.nixosModules.default
    {
      system.stateVersion = "24.11";
      wsl.enable = true;
    }
  ];
  specialArgs = {
    primaryUser = "abentley";
  };
}
