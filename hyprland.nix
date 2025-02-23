{pkgs, ...}:
{
  programs.hyprland.enable = true;
  environment.systemPackages = [
      pkgs.kitty
      pkgs.wofi
      # Animated wallpaper
      pkgs.swww
      # Automate plug/unplug behaviour
      pkgs.kanshi
      # Clipboard functionality?
      pkgs.wl-clipboard
      pkgs.waybar
  ];
}
