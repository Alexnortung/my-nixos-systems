{ stdenv, pkgs, ... }:

let
  version = "3.6";
in
stdenv.mkDerivation {
  version = version;
  pname = "sagetex";
  passthru.tlType = "run";
  src = pkgs.fetchurl {
    url = "https://github.com/sagemath/sagetex/releases/download/v${version}/sagetex-${version}.tar.gz";
    sha256 = "sha256:09wa7smwr6j4zid8vd3lqxa90hdhgnx5l0avjf2d5lx6p09xvw01";
  };

  installPhase = ''
    path="$out/tex/latex/sagetex"
    mkdir -p "$path"
    cp -va *.sty *.cfg *.def "$path/"
  '';
}
