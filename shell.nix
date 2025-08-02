let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.05";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
  selection =
    (import ./suites/base.nix {
      config = { };
      pkgs = pkgs;
    }).environment.systemPackages;
in

pkgs.mkShellNoCC {
  packages = with pkgs; selection ++ [ pkgs.neovim ];
}
