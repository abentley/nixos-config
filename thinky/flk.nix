{ self, nixpkgs }:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ../base.nix
    ../graphical.nix
    ../audio.nix
  ];
}
