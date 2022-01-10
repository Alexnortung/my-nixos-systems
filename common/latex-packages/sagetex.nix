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
    sha256 = "fzol58VztvRLJHaaMYQ8gmMvSa5Lu2AZJ74buDPle4E=";
  };

  installPhase = ''
    path="$out/tex/latex/sagetex"
    mkdir -p "$path"
    cp -va *.sty *.cfg *.def "$path/"
  '';
}
