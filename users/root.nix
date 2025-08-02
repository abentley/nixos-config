{ pkgs, ... }:
{
  home.stateVersion = "24.11";
  programs.neovim = import ../config/neovim-config.nix;
  programs.bash.enable = true;
}
