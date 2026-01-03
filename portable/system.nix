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
      { pkgs, ... }:
      {
        # Allow installation of non-free packages, like the firmware needed for this wifi card.
        nixpkgs.config.allowUnfree = true;

        # This MUST be set to a unique value for each system.
        networking.hostName = "portable";

        # Enable our custom features
        myFeatures.homeManager.enable = true;

        # Add QEMU tools needed for the qcow2 loopback device.
        environment.systemPackages = [ pkgs."qemu-utils" ];

        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Define the filesystems.
        fileSystems = {
          "/" = {
            device = "/dev/disk/by-uuid/8843fe4a-9bb5-4039-99ad-1e7d3383b64e";
            fsType = "ext4";
          };

          "/boot" = {
            device = "/dev/disk/by-uuid/5C52-12BB";
            fsType = "vfat";
          };

          # 1. Mount the exfat "transfer" partition using its UUID.
          "/transfer" = {
            device = "/dev/disk/by-uuid/6FFD-FA79";
            fsType = "exfat";
            options = [ "defaults" "uid=1000" "gid=100" ];
          };
        };

        # 4. Explicitly define the mount unit for /data to control its dependencies.
        systemd.mounts = [{
          where = "/data";
          what = "/dev/nbd0";
          type = "ext4";
          options = "defaults,nofail";
          requires = [ "nbd-for-data.service" ];
          after = [ "nbd-for-data.service" ];
          wantedBy = [ "multi-user.target" ];
        }];

        # 2. A one-shot service to create and format the qcow2 file on the first boot.
        systemd.services.setup-qcow2 = {
          description = "Create and format QCOW2 storage file";
          wantedBy = [ "multi-user.target" ];
          after = [ "transfer.mount" ];
          before = [ "nbd-for-data.service" ];
          serviceConfig.Type = "oneshot";
          path = with pkgs; [ "qemu-utils" e2fsprogs util-linux kmod ];
          script = ''
            set -e
            QCOW_FILE="/transfer/nixos_storage.qcow2"
            NBD_DEV="/dev/nbd0"

            # Load the nbd kernel module if it's not already.
            modprobe nbd max_part=8

            # Create the backing qcow2 file if it doesn't exist.
            if [ ! -f "$QCOW_FILE" ]; then
              echo "Creating 500GB qcow2 image at $QCOW_FILE..."
              qemu-img create -f qcow2 "$QCOW_FILE" 500G
            fi

            # Temporarily connect the device to format it, if needed.
            qemu-nbd --disconnect "$NBD_DEV" || true
            qemu-nbd --connect="$NBD_DEV" "$QCOW_FILE"
            sleep 1 # Give the device a moment to settle.
            if ! blkid -p -o value -s TYPE "$NBD_DEV"; then
                echo "Formatting $NBD_DEV with ext4..."
                mkfs.ext4 "$NBD_DEV"
            fi
            qemu-nbd --disconnect "$NBD_DEV"
          '';
        };

        # 3. A long-running service to keep the qcow2 file connected as /dev/nbd0.
        systemd.services.nbd-for-data = {
          description = "Connect QCOW2 file to NBD device";
          wantedBy = [ "multi-user.target" ];
          after = [ "setup-qcow2.service" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs."qemu-utils"}/bin/qemu-nbd --connect=/dev/nbd0 /transfer/nixos_storage.qcow2 --fork=no";
            ExecStop = "${pkgs."qemu-utils"}/bin/qemu-nbd --disconnect /dev/nbd0";
            Restart = "on-failure";
          };
        };

        # This is a portable system, so we don't want a hardware-configuration.nix
        # Instead, we'll enable some generic features.
        powerManagement.enable = true;
        hardware = {
          enableRedistributableFirmware = true;

          # Add non-free firmware for hardware like Qualcomm Wi-Fi.
          firmware = [ pkgs.firmwareLinuxNonfree ];
        };


        # Add common USB storage drivers to the initrd to ensure the SSD is found at boot.
        boot.initrd.availableKernelModules = [
          "xhci_pci"
          "ehci_pci"
          "uas"
          "usb_storage"
          "sd_mod"
        ];

        # Nix settings
        nix.settings.auto-optimise-store = true;
      }
    )
  ];
}
