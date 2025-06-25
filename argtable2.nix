# argtable2.nix
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation rec {
  pname = "argtable2";
  version = "2.13";

  src = pkgs.fetchurl {
    url = "http://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz";
    sha256 = "sha256-j3fop87VMBr24i9HMC/bw7H/QfK4PEPHeuXKBBdx3b8=";
  };

  nativeBuildInputs = with pkgs; [ ];

  meta = with pkgs.lib; {
    description = "A library for parsing GNU style command line arguments";
    homepage = "http://argtable.sourceforge.net/";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
