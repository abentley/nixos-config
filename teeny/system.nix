# Provide a NixOS system configuration for the teeny machine.
{
  self,
  nixpkgs,
  old-nixpkgs,
  home-manager,
  ...
}:
let
  custom = (
    { config, pkgs, lib, ... }:
    let
      zfsCompatibleKernelPackages = lib.filterAttrs (
        name: kernelPackages:
        (builtins.match "linux_[0-9]+_[0-9]+" name) != null
        && (builtins.tryEval kernelPackages).success
        && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
      ) pkgs.linuxKernel.packages;
      latestKernelPackage = lib.last (
        lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
          builtins.attrValues zfsCompatibleKernelPackages
        )
      );
    in {
      # Note this might jump back and forth as kernels are added or removed.
      boot.kernelPackages = latestKernelPackage;
      # Bootloader.
      boot.loader.grub = {
        gfxmodeBios = "1920x1080x32";
        splashImage = ./darktrees.png;
      };
      boot.initrd.kernelModules = [ "i915" ];
      boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21HNXBG433208Y";
      boot.loader.grub.zfsSupport = true;

      # Don't actually want this for booting, but this seems to be how you get it
      # at all.
      boot.supportedFilesystems = [
        "bcachefs"
        "zfs"
      ];
      # boot.zfs.enabled = true;
      boot.zfs.devNodes = "/dev/disk/by-partuuid/ed4867b2-c1f2-7249-9a71-a904b9d8d9f8";

      boot.zfs.extraPools = [ "raidpool2" ];

      services.zfs.autoScrub.enable = true;

      fileSystems."/mnt/bcachefs" = {
        device = "/dev/disk/by-uuid/33ac4789-8fdc-4774-ab7a-1f4384ca0aeb";
        fsType = "bcachefs";
        options = [ "nofail" ];
      };

  fileSystems."/mnt/250G" = {
    device = "/dev/disk/by-uuid/b1724b65-c2ac-4d18-905b-9dfd1058339a";
    fsType = "ext4";
    options = [ "noauto" ];
  };
  networking.hostName = "teeny"; # Define your hostname.
  # Required for zfs
  networking.hostId = "21d28d23";

  # This is more of a graphical-server config, but I only have one of those.
  services.xserver.displayManager.gdm.autoSuspend = false;
  environment.systemPackages = [
    pkgs.mplayer
  ];

      virtualisation.docker.enable = true;
      users.users = {
        abentley.extraGroups = [ "docker" ];
        jellyfin.extraGroups = [ "docker" ];
      };
    }
  );
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hardware-configuration.nix
    ../suites/graphical-computer.nix
    ../features/jellyfin.nix
    ../features/incus.nix
    ../features/grub.nix
    ../suites/base.nix
    #      ../features/podman.nix
    ./samba-teeny.nix
    # ../../samba-vr.nix
    ../features/hyprland.nix
    ../features/early-console.nix
    ../base-configuration.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
    custom
  ];
  specialArgs = {
    primaryUser = "abentley";
    old-nixpkgs = old-nixpkgs;
    consoleFontName = "spleen";
  };
}
