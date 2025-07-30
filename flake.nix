{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    old-nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    old-nixpkgs.flake = false;
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      old-nixpkgs,
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
        old-nixpkgs = old-nixpkgs;
        home-manager = home-manager;
      };
      nixosConfigurations.gamey-wsl = import ./git/gamey-wsl/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
        nixos-wsl = nixos-wsl;
      };
      nixosConfigurations.hp = import ./git/hp/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
      };
      nixosConfigurations.skinny = import ./git/skinny/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
      };
      nixosConfigurations.handy = import ./git/handy/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
      };
    };
}
