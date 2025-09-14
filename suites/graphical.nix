{ config, pkgs, ... }:
{
  programs.wireshark.enable = true;
  # Enable "Desktop sharing"
  services.gnome.gnome-remote-desktop.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "gnome-remote-desktop";
  services.xrdp.openFirewall = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    baobab
    halloy
    meld
    mtr-gui
  ];
  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
  ];
}
