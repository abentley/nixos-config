{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.thinky = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ 
    ./git/thinky/configuration.nix
    ./git/base.nix
    ./git/graphical.nix
    ./git/audio.nix
    ];
    };
  };
}
