{ config, pkgs, ... }:
{
  console = {
    earlySetup = true; # Apply font early in boot process
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz"; # Example: 32pt Terminus font
    packages = with pkgs; [ terminus_font ]; # Ensure the font package is available
    keyMap = "us"; # Your preferred keymap
  };
}
