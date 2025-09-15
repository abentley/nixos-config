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
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../features/options.nix # Add the new options file
    home-manager.nixosModules.home-manager
    custom
    {
      # Enable features
      myFeatures = {
        systemdBoot.enable = true;
        hyprland = {
          enable = true;
          primaryUser = "abentley";
        };
        flakeSupport.enable = true;
        earlyConsole = {
          enable = true;
          consoleFontName = "terminus";
        };
        homeManager.enable = true;
      };
    }
  ];
}
