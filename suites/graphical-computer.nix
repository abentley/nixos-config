# Provide a fully-functional graphical computer configuration,
# including daily-driver applications such as Chrome and Discord.
# GNOME is the base configuration, but Hyperland can be added as a feature.
{ config, pkgs, ... }:
{
  imports = [ ./graphical.nix ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable TeamViewer
  services.teamviewer.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable "Desktop sharing"
  services.gnome.gnome-remote-desktop.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    beeper
    discord
    easyeffects
    # Gnome Loupe has bad fullscreen support
    eog
    google-chrome
    gnomeExtensions.appindicator
    # I guess I'm a creature of habit.
    gnomeExtensions.dash-to-dock
    # edit images
    gimp-with-plugins
    gparted
    halloy
    # Wayland-compatible synergy!
    input-leap
    pwvucontrol
    rhythmbox
    vesktop
    vlc
    warpinator
    # NVIM relies on $WAYLAND_DISPLAY to use wayland-specific tools.  So use an
    # X11 tool instead.
    xsel
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # 42000, 42001: Warpinator.  Possibly unnecessary.
  networking.firewall.allowedTCPPorts = [
    42000
    42001
  ];
  networking.firewall.allowedUDPPorts = [
    42000
    42001
  ];
  programs.zoom-us.enable = true;
}
