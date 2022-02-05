{ pkgs, lib, ... }:

let
  unstable = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    rev = "a529f0c125a78343b145a8eb2b915b0295e4f459";
  }) {};
  sagetex.pkgs = [
    unstable.sagetex
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
