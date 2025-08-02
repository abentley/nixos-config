{
  config,
  pkgs,
  consoleFontName,
  ...
}:
let
  consoleFont = consoleFonts.${consoleFontName};
  consoleFonts = {
    spleen = rec {
      path = "${pkg}/share/consolefonts/spleen-32x64.psfu";
      pkg = pkgs.spleen;
    };
    terminus = rec {
      path = "${pkg}/share/consolefonts/ter-i32b.psf.gz";
      pkg = pkgs.terminus_font;
    };
  };
in
{
  console = {
    earlySetup = true; # Apply font early in boot process
    font = consoleFont.path;
    packages = [ consoleFont.pkg ]; # Ensure the font package is available
    keyMap = "us"; # Your preferred keymap
  };
}
