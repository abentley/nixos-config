{
  self,
  nixpkgs,
  old-nixpkgs,
  home-manager,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hardware-configuration.nix
    ./specific.nix
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
  ];
  specialArgs = {
    primaryUser = "abentley";
    old-nixpkgs = old-nixpkgs;
    consoleFontName = "spleen";
  };
}
