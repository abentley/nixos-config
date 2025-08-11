{
  self,
  nixpkgs,
  old-nixpkgs,
  home-manager,
  ...
}:
let
  custom = (
    { config, pkgs, ... }:

    {
      # Bootloader.
      boot.loader.grub = {
        gfxmodeBios = "1920x1080x32";
        splashImage = ./darktrees.png;
      };
      boot.initrd.kernelModules = [ "i915" ];

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
    ./teeny.nix
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
