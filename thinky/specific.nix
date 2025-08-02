{ config, pkgs, ... }:
{
  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    gfxmodeEfi = "1366x768x32";
    useOSProber = true;
    # efiInstallAsRemovable = true;
    splashImage = "/home/abentley/treemoon2.png";
    # font = "${pkgs.hack-font}/share/fonts/hack/Hack-Regular.ttf";
    # fontSize = 24;
  };
  boot.initrd.kernelModules = [ "i915" ];

  # boot.loader.systemd-boot.enable = true;
  # Conflicts with boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.plymouth.enable = true;

  networking.hostName = "thinky"; # Define your hostname.

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  environment.systemPackages = with pkgs; [
    shotwell
  ];
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

}
