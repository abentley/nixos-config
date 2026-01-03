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
          path = [ pkgs."qemu-utils" pkgs.e2fsprogs pkgs.util-linux pkgs.kmod ];
          script = ''
            set -ex # Exit on error AND print all commands
            QCOW_FILE="/transfer/nixos_storage.qcow2"
            NBD_DEV="/dev/nbd0"

            echo "--- Starting setup-qcow2 script ---"
            modprobe nbd max_part=8

            if [ ! -f "$QCOW_FILE" ]; then
              echo "Creating 500GB qcow2 image at $QCOW_FILE..."
              qemu-img create -f qcow2 "$QCOW_FILE" 500G
            fi

            echo "Connecting NBD device..."
            qemu-nbd --disconnect "$NBD_DEV" || true
            qemu-nbd --connect="$NBD_DEV" "$QCOW_FILE"

            FORMATTED=false
            for i in $(seq 1 5); do
              echo "Polling for filesystem, attempt $i..."
              # Run blkid and check exit code explicitly
              if blkid -p -o value -s TYPE "$NBD_DEV"; then
                echo "blkid succeeded. Filesystem found."
                FORMATTED=true
                break
              else
                echo "blkid failed with exit code $?. Waiting..."
                sleep 1
              fi
            done

            if [ "$FORMATTED" = "false" ]; then
              echo "No filesystem found after polling. Formatting $NBD_DEV with ext4..."
              mkfs.ext4 -F "$NBD_DEV"
            else
              echo "Skipping format as filesystem already exists."
            fi

            echo "Disconnecting NBD device..."
            qemu-nbd --disconnect "$NBD_DEV"
            echo "--- Finished setup-qcow2 script ---"
          '';
        };

        # 3. A long-running service to keep the qcow2 file connected as /dev/nbd0.
        systemd.services.nbd-for-data = {
          description = "Connect QCOW2 file to NBD device";
          wantedBy = [ "multi-user.target" ];
          after = [ "setup-qcow2.service" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs."qemu-utils"}/bin/qemu-nbd --connect=/dev/nbd0 /transfer/nixos_storage.qcow2 --persistent";
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
