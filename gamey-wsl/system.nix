# Provide a NixOS system configuration for the gamey-wsl environment.
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
    home-manager.nixosModules.home-manager
    nixos-wsl.nixosModules.default
    ../features/options.nix # Add the new options file
    {
      system.stateVersion = "24.11";
      wsl.enable = true;
      # Enable features
      myFeatures = {
        flakeEnablement.enable = true;
        homeManager.enable = true;
      };
    }
  ];
  specialArgs = {
    primaryUser = "abentley";
  };
}
