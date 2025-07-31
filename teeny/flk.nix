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
    ../graphical.nix
    ../jellyfin.nix
    ../incus.nix
    ./teeny.nix
    ../base.nix
    #      ./podman.nix
    ./samba-teeny.nix
    ../../samba-vr.nix
    ../hyprland.nix
    ../flake-enablement.nix
    ../early-console.nix
    ./configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.abentley = ../abentley.nix;
      home-manager.users.root = ../root.nix;
      home-manager.backupFileExtension = "backup";
    }
  ];
  specialArgs = {
    primaryUser = "abentley";
    old-nixpkgs = old-nixpkgs;
    consoleFontName = "spleen";
  };
}
