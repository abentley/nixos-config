{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "hp"; # Define your hostname.

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

}
