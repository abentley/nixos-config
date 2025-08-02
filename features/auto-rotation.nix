{ config, pkgs, ... }:

{
  hardware.sensor.iio.enable = true;
  programs.iio-hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    # Needed for auto-rotation?
    gjs
    iio-hyprland
    # Needed for iio-hyprland
    jq
    gnomeExtensions.screen-rotate
  ];
}
