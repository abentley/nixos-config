# default.nix
{
  pkgs ? import <nixpkgs> { },
}:
let
  argtable2-local = pkgs.callPackage ./argtable2.nix { };
in
pkgs.stdenv.mkDerivation rec {
  pname = "comskip";
  version = "0.82.011";

  src = pkgs.fetchFromGitHub {
    owner = "erikkaashoek";
    repo = "Comskip";
    rev = "2ef86841cd84df66fe0e674f300ee49cef6e097a";
    sha256 = "sha256-4ef/YZpaiSp3VeSiU6mRR38GjkrzxboI0/VXQ5QQiUM=";
  };

  buildInputs = with pkgs; [
    ffmpeg_4 # Comskip relies heavily on ffmpeg libraries
    argtable2-local # A common dependency for CLI parsing
  ];

  nativeBuildInputs = with pkgs; [
    # These are often implicitly handled by stdenv for autoconf projects,
    # but good to be aware of.
    autoconf
    automake
    libtool
    # This automatically runs to generate config
    autoreconfHook
    pkg-config
  ];

  meta = with pkgs.lib; {
    description = "Comskip: Detect and mark commercials in video files";
    homepage = "https://github.com/erikkaashoek/Comskip";
    license = licenses.gpl2Plus; # Check Comskip's actual license
    platforms = platforms.linux; # Or other platforms it supports
  };
}
