{
  self,
  nixpkgs,
  home-manager,
  nixos-wsl,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ../suites/base.nix
    ../suites/graphical.nix
    ../features/flake-enablement.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
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
