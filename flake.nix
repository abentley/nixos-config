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
    let
      # Pass the system attribute directly to the Nixpkgs import.
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = { };
        overlays = [ ];
      };
      # Define a list of packages in a central place
      selection =
        with pkgs;
        (import ./suites/base.nix {
          config = { };
          pkgs = pkgs;
        }).environment.systemPackages
        ++ [
          neovim
          # add other packages here
        ];
    in
    {
      # The devShell output for a temporary environment.
      devShells.x86_64-linux.default = pkgs.mkShellNoCC {
        packages = selection;
      };

      # A separate, installable package that contains all your dev tools.
      packages.x86_64-linux.default = pkgs.buildEnv {
        name = "my-dev-tools";
        paths = selection;
      };

      nixosConfigurations.thinky = import ./thinky/flk.nix inputs;
      nixosConfigurations.teeny = import ./teeny/flk.nix inputs;
      nixosConfigurations.gamey-wsl = import ./gamey-wsl/flk.nix inputs;
      nixosConfigurations.hp = import ./hp/flk.nix inputs;
      nixosConfigurations.skinny = import ./skinny/flk.nix inputs;
      nixosConfigurations.handy = import ./handy/flk.nix inputs;
    };
}
