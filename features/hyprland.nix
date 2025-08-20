{ pkgs, primaryUser, ... }:
{
  programs.hyprland.enable = true;
  environment.systemPackages = [
    pkgs.kitty
    pkgs.wofi
    pkgs.walker
    # Animated wallpaper
    pkgs.swww
    # Automate plug/unplug behaviour
    pkgs.kanshi
    # Clipboard functionality?
    pkgs.wl-clipboard
    pkgs.waybar
    # Needed for volume in hyprland
    pkgs.pulseaudio
    # Needed for brightness in hyprland
    pkgs.brightnessctl
    # Provides nm-connection-editor
    pkgs.networkmanagerapplet
    # Dock
    pkgs.nwg-dock-hyprland
    pkgs.pavucontrol
    # Find key symbols
    pkgs.xorg.xev
    pkgs.hyprcursor
    # Cursor set
    pkgs.bibata-cursors
    pkgs.adwaita-icon-theme
    pkgs.blueman
  ];
  users.users.${primaryUser}.extraGroups = [
    # video is needed for udevd to permit brightness control
    "video"
    # input is used by to display key lock status
    "input"
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";
  };
  home-manager.users.abentley = {
    home.file.".config/hypr/shared.conf".source = ../config/hypr/shared.conf;
    home.file.".config/hypr/nix.conf".source = ../config/hypr/nix.conf;
    home.file.".config/hypr/autorotate.conf".source = ../config/hypr/autorotate.conf;
    home.file.".config/waybar/config.jsonc".source = ../config/waybar/config.jsonc;
    home.file.".config/waybar/style.css".source = ../config/waybar/style.css;
    home.file.".config/waybar/power_menu.xml".source = ../config/waybar/power_menu.xml;
    home.file.".config/walker/config.toml".source = ../config/walker/config.toml;
    home.file.".config/walker/themes/default.toml".source = ../config/walker/themes/default.toml;
    home.file.".config/walker/themes/default.css".source = ../config/walker/themes/default.css;
    home.file.".config/walker/themes/default_window.toml".source =
      ../config/walker/themes/default_window.toml;
  };
}
