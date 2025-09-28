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

      nixosConfigurations.lappy = import ./lappy/system.nix inputs;
      nixosConfigurations.thinky = import ./thinky/system.nix inputs;
      nixosConfigurations.thinky-wsl = import ./thinky-wsl/system.nix inputs;
      nixosConfigurations.teeny = import ./teeny/system.nix inputs;
      nixosConfigurations.gamey-wsl = import ./gamey-wsl/system.nix inputs;
      nixosConfigurations.hp = import ./hp/system.nix inputs;
      nixosConfigurations.skinny = import ./skinny/system.nix inputs;
      nixosConfigurations.handy = import ./handy/system.nix inputs;
    };
}
