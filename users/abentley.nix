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
  '';
  home.file.".config/hypr/shared.conf".source = ../config/hypr/shared.conf;
  home.file.".config/hypr/nix.conf".source = ../config/hypr/nix.conf;
  home.file.".config/hypr/autorotate.conf".source = ../config/hypr/autorotate.conf;
  home.file.".config/waybar/config.jsonc".source = ../config/waybar/config.jsonc;
  home.file.".config/waybar/style.css".source = ../config/waybar/style.css;
  home.file.".config/waybar/power_menu.xml".source = ../config/waybar/power_menu.xml;
  home.file.".config/kitty/kitty.conf".source = ../config/kitty.conf;
  home.file.".local/share/applications/beeper.desktop".source = ../config/applications/beeper.desktop;
  home.file.".config/walker/config.toml".source = ../config/walker/config.toml;
  home.file.".config/walker/themes/default.toml".source = ../config/walker/themes/default.toml;
  home.file.".config/walker/themes/default.css".source = ../config/walker/themes/default.css;
  home.file.".config/walker/themes/default_window.toml".source =
    ../config/walker/themes/default_window.toml;
}
