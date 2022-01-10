{ pkgs, lib, ... }:

let
  sagetex-pkg = pkgs.callPackage ./latex-packages/sagetex.nix {};
  sagetex.pkgs = [
    sagetex-pkg
  ];
in
let
  my_latex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full;
    #inherit sagetex;
  };
in {
  environment.systemPackages = [
    my_latex
  ];
}
