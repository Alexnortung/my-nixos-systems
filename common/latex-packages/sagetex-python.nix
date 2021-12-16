{ pkgs, ... }:

let 
  #sage-python = pkgs.python3.pkgs.toPythonModule pkgs.sage;
  sage-python = pkgs.callPackage ./sage-python.nix {};
in
pkgs.python3.pkgs.buildPythonPackage rec {
  pname = "sagetex-python";
  version = "3.6";

  src = pkgs.fetchurl {
    url = "https://github.com/sagemath/sagetex/releases/download/v${version}/sagetex-${version}.tar.gz";
    sha256 = "sha256:09wa7smwr6j4zid8vd3lqxa90hdhgnx5l0avjf2d5lx6p09xvw01";
  };

  nativeBuildInputs = [
    pkgs.python3Packages.pyparsing
  ];

  pythonPath = [
    sage-python
  ];

  checkPhase = ''
    runHook preCheck

    python -c "import sagetex; print('hello world')"

    runHook postCheck
  '';

  doCheck = true;
  #pythonImportsCheck = [ "sagetex" "sagetexparse" ];

  #meta = with lib; {
  #  homepage = "https://github.com/pytoolz/toolz";
  #  description = "List processing tools and functional utilities";
  #  license = licenses.bsd3;
  #  maintainers = with maintainers; [ fridh ];
  #};
}
