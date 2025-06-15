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
  ];
  users.users.${primaryUser}.extraGroups = [
    # video is needed for udevd to permit brightness control
    "video"
    # input is used by to display key lock status
    "input"
  ];
}
