{ pkgs, ... }:

pkgs.python3.pkgs.buildPythonPackage rec {
  pname = "sage";
  version = "9.4";

  src = pkgs.fetchurl {
    url = "https://github.com/sagemath/sage/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256:198fvfrga9rniphwv864wkgrkcxcbdci4cf1mlylihkrwqvhy6a7";
  };

  nativeBuildInputs = [
    pkgs.python3Packages.cython
    pkgs.python3Packages.jinja2
    pkgs.python3Packages.pkgconfig
  ];

  configurePhase = ''
    runHook preConfigure

    make configure
    cd src/

    runHook postConfigure
  '';

  pythonImportsCheck = [ "sage" ];
}
