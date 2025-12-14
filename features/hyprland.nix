# Provide the Hyprland compositor as a feature, including all the functionality
# that must be re-implemented to provide similar facilities to GNOME
{ pkgs, primaryUser, ... }:
let
  wallpaper = pkgs.fetchurl {
    url = "https://assets.aaronbentley.com/PA024118.ORF.jpg";
    sha256 = "sha256-WHjK9rAB/aSmIjtowx+eiETqYbOISveTjReZgzfP6iA=";
  };
in
{
  programs.hyprland.enable = true;
  environment.systemPackages = [
    pkgs.adwaita-icon-theme
    # Cursor set
    pkgs.bibata-cursors
    # Needed for brightness in hyprland
    pkgs.brightnessctl
    pkgs.hyprcursor
    # Suggested session locker
    # pkgs.hyprlock
    # Automate plug/unplug behaviour
    pkgs.kanshi
    pkgs.kitty
    # Provides nm-connection-editor
    pkgs.networkmanagerapplet
    # Dock
    pkgs.nwg-dock-hyprland
    # Suggested notification agent.
    pkgs.mako
    pkgs.pavucontrol
    # Needed for volume in hyprland
    pkgs.pulseaudio
    # Suggested idle lock
    # pkgs.swayidle
    # Animated wallpaper
    pkgs.swww
    pkgs.walker
    pkgs.wofi
    # Clipboard functionality?
    pkgs.wl-clipboard
    # Find key symbols
    pkgs.xorg.xev
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
  services.blueman.enable = true;

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";
  };
  home-manager.users.abentley = {
    home.file.".config/hypr/extra.conf".text = ''
      exec-once = swww-daemon
      exec-once = swww img ${wallpaper} --outputs all
      exec-once = mako
    '';
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
    home.file.".config/kanshi/config".source = ../config/kanshi/config;
  };
  programs = {
    waybar.enable = true;
  };
}
