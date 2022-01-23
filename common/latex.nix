{ pkgs, lib, ... }:

let
  sagetex-pkgs = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/pull/151876/merge";
    rev = "b9a8932892b37ca8881772d88181637213f404cf";
  }) {};
  sagetex.pkgs = [
    sagetex-pkgs.sagetex
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
  ];
}
