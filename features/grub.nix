# Provide a feature to configure the GRUB bootloader.
{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
}
