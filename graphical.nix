{ config, pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable TeamViewer
  services.teamviewer.enable = true;

  # Enable "Desktop sharing"
  services.gnome.gnome-remote-desktop.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "gnome-remote-desktop";
  services.xrdp.openFirewall = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    google-chrome
    # NVIM relies on $WAYLAND_DISPLAY to use wayland-specific tools.  So use an
    # X11 tool instead.
    xsel
    # I guess I'm a creature of habit.
    gnomeExtensions.dash-to-dock
    # edit images
    gimp-with-plugins
    # Can be useful as an IDE
    terminator
    # Wayland-compatible synergy!
    input-leap
    beeper
    halloy
    wireshark
    discord
  ];
}
