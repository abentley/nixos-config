{ pkgs, ... }:
{
  home.stateVersion = "24.11";
  #home.packages = [ ];
  programs.neovim = import ./neovim-config.nix // {
    #    plugins = [ vimPlugins.vim-jsonnet ];
  };
  programs.bash.enable = true;
  home.file.".config/halloy/config.toml".text = ''
    [servers.liberachat]
    nickname = "abentley"
    server = "irc.libera.chat"
    channels = ["#halloy"]
  '';
  home.file.".config/hypr/shared.conf".source = ./hyprland/shared.conf;
  home.file.".config/hypr/nix.conf".source = ./hyprland/nix.conf;
  home.file.".config/hypr/autorotate.conf".source = ./hyprland/autorotate.conf;
  home.file.".config/waybar/config.jsonc".source = ./waybar/config.jsonc;
  home.file.".config/waybar/style.css".source = ./waybar/style.css;
  home.file.".config/waybar/power_menu.xml".source = ./waybar/power_menu.xml;
  home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
  home.file.".local/share/applications/beeper.desktop".source = ./applications/beeper.desktop;
  home.file.".config/walker/config.toml".source = ./walker/config.toml;
  home.file.".config/walker/themes/default.toml".source = ./walker/themes/default.toml;
  home.file.".config/walker/themes/default.css".source = ./walker/themes/default.css;
  home.file.".config/walker/themes/default_window.toml".source = ./walker/themes/default_window.toml;
}
