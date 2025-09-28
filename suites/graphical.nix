# Provide configuration that may be useful for a graphical VM or in WSL.
# Daily-driver programs such as Chrome are excluded because they would be run
# on the host machine.
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
    # Can be useful as an IDE
    terminator
  ];
  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
  ];
}
