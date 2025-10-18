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
    ../suites/base.nix
    ../suites/graphical.nix
    ../suites/wsl.nix
    home-manager.nixosModules.home-manager
    nixos-wsl.nixosModules.default
    ../features/options.nix # Add the new options file
    {
      networking.hostName = "gamey-wsl";
      system.stateVersion = "24.11";
      # Enable features
      myFeatures = {
        flakeSupport.enable = true;
        homeManager.enable = true;
        docker = {
          enable = true;
          primaryUser = "abentley";
        };
      };
    }
  ];
  specialArgs = {
    primaryUser = "abentley";
  };
}
