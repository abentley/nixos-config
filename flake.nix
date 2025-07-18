{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
    }:
    {
      nixosConfigurations.thinky = import ./git/thinky/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
      };
      nixosConfigurations.teeny = import ./git/teeny/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
      };
      nixosConfigurations.gamey-wsl = import ./git/gamey-wsl/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
        nixos-wsl = nixos-wsl;
      };
    };
}
