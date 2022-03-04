{ pkgs, lib, ... }:

let
  sagetex.pkgs = [
    pkgs.sagetex
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
    pkgs.python3Packages.pygments
  ];
}
