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
      packages.x86_64-linux.default =
        let
          pkgs = import nixpkgs {
            config = { };
            overlays = [ ];
            system = "x86_64-linux";
          };
          selection =
            (import ./suites/base.nix {
              config = { };
              pkgs = pkgs;
            }).environment.systemPackages
            ++ [ pkgs.neovim ];
        in
        pkgs.mkShellNoCC {
          packages = selection;
        };

      nixosConfigurations.thinky = import ./thinky/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
      };
      nixosConfigurations.teeny = import ./teeny/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        old-nixpkgs = old-nixpkgs;
        home-manager = home-manager;
      };
      nixosConfigurations.gamey-wsl = import ./gamey-wsl/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
        nixos-wsl = nixos-wsl;
      };
      nixosConfigurations.hp = import ./hp/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
      };
      nixosConfigurations.skinny = import ./skinny/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
      };
      nixosConfigurations.handy = import ./handy/flk.nix {
        self = self;
        nixpkgs = nixpkgs;
        home-manager = home-manager;
      };
    };
}
