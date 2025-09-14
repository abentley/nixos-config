# Provide a user profile for the abentley user.
{ pkgs, ... }:
{
  home.stateVersion = "24.11";
  #home.packages = [ ];
  programs.neovim = import ../config/neovim-config.nix // {
    #    plugins = [ vimPlugins.vim-jsonnet ];
  };
  programs.bash.enable = true;
  home.file.".config/halloy/config.toml".text = ''
    [servers.liberachat]
    nickname = "abentley"
    server = "irc.libera.chat"
    channels = ["#halloy"]
    [font]
    size = 24
  '';
  home.file.".local/share/applications/beeper.desktop".source = ../config/applications/beeper.desktop;
  home.file.".config/kitty/kitty.conf".source = ../config/kitty.conf;
}
