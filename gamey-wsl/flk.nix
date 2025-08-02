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
    ../suites/base.nix
    ../suites/graphical-non-host.nix
    ../features/flake-enablement.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.abentley = ../users/abentley.nix;
      home-manager.users.root = ../users/root.nix;
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
