# Configuration for the portable SSD system
{
  self,
  nixpkgs,
  home-manager,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../features/options.nix
    ../base-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    home-manager.nixosModules.home-manager

    (
      { ... }:
      {
        # This MUST be set to a unique value for each system.
        networking.hostName = "portable";

        # Enable our custom features
        myFeatures.homeManager.enable = true;

        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Define the filesystems. Using UUIDs is the most robust method.
        fileSystems = {
          "/" = {
            device = "/dev/disk/by-uuid/8843fe4a-9bb5-4039-99ad-1e7d3383b64e";
            fsType = "ext4";
          };

          "/boot" = {
            device = "/dev/disk/by-uuid/5C52-12BB";
            fsType = "vfat";
          };
        };

        # This is a portable system, so we don't want a hardware-configuration.nix
        # Instead, we'll enable some generic features.
        powerManagement.enable = true;

        # Add common USB storage drivers to the initrd to ensure the SSD is found at boot.
        boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "uas" "usb_storage" "sd_mod" ];

        # Nix settings
        nix.settings.auto-optimise-store = true;
      }
    )
  ];
}
