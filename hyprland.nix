{ pkgs, ... }:
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
  ];
  # video is needed for udevd to permit brightness control
  users.users.abentley.extraGroups = [ "video" ];
}
