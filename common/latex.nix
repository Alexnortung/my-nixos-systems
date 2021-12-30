{ pkgs, lib, ... }:

let
  #sagetex-python = pkgs.callPackage ./latex-packages/sagetex-python.nix {};
  sagetex-pkg = pkgs.callPackage ./latex-packages/sagetex.nix {};
  #sagetex-python = pkgs.python3.pkgs.toPythonModule sagetex-pkg;
  sagetex.pkgs = [
    sagetex-pkg
  ];
in
let
  my_latex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full;
    inherit sagetex;
  };
in {
  environment.systemPackages = [
    my_latex
    #sagetex-python
  ];
}
