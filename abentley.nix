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
  home.file.".config/waybar/config.jsonc".source = ./waybar/config.jsonc;
  home.file.".config/waybar/style.css".source = ./waybar/style.css;
  home.file.".config/waybar/power_menu.xml".source = ./waybar/power_menu.xml;
  home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
  home.file.".local/share/applications/beeper.desktop".source = ./applications/beeper.desktop;
}
