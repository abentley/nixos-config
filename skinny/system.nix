# Provide a NixOS system configuration for the skinny machine.
{
  self,
  nixpkgs,
  home-manager,
  ...
}:
let
  custom = ({
    # Bootloader.
    boot = {
      loader.systemd-boot.consoleMode = "0";
      initrd.kernelModules = [ "i915" ];
    };
    networking.hostName = "skinny"; # Define your hostname.
  });
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../base-configuration.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    home-manager.nixosModules.home-manager
    ../features/options.nix # Add the new options file
    custom
    {
      # Enable features
      myFeatures = {
        systemdBoot.enable = true;
        hyprland = {
          enable = true;
          primaryUser = "abentley";
        };
        flakeEnablement.enable = true;
        earlyConsole = {
          enable = true;
          consoleFontName = "terminus";
        };
        homeManager.enable = true;
      };
    }
  ];
}
