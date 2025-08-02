{
  self,
  nixpkgs,
  old-nixpkgs,
  home-manager,
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hardware-configuration.nix
    ../suites/graphical-computer.nix
    ../features/jellyfin.nix
    ../features/incus.nix
    ./teeny.nix
    ../suites/base.nix
    #      ../features/podman.nix
    ./samba-teeny.nix
    # ../../samba-vr.nix
    ../features/hyprland.nix
    ../features/early-console.nix
    ./configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.abentley = ../users/abentley.nix;
      home-manager.users.root = ../users/root.nix;
      home-manager.backupFileExtension = "backup";
    }
  ];
  specialArgs = {
    primaryUser = "abentley";
    old-nixpkgs = old-nixpkgs;
    consoleFontName = "spleen";
  };
}
