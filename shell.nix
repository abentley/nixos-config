let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
  selection = (import ./base.nix {config = {}; pkgs=pkgs;}).environment.systemPackages;
in

pkgs.mkShellNoCC {
  packages = with pkgs; selection ++ [pkgs.neovim];
}
