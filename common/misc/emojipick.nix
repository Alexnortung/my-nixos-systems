{ pkgs, nixpkgs-emojipick, ... }:

let
  pkgs-emojipick = nixpkgs-emojipick.pkgs;
  # pkgs-emojipick = import (builtins.fetchGit {
  #   url = "https://github.com/NixOS/nixpkgs/";
  #   ref = "refs/pull/158187/merge";
  #   rev = "2325a754e19e40b227b50323acfedca41836fbf9";
  # }) {};
  # pkgs-emojipick = import (builtins.fetchTarball {
  #   url = "https://github.com/NixOS/nixpkgs/archive/2325a754e19e40b227b50323acfedca41836fbf9.tar.gz";
  #   sha256 = "0jj0qndh36fjgvh6d2r2xyqniz4042wgd4qpg7r0kh7lf3xcw8jn";
  # }) {};
in
{
  nixpkgs.config.packageOverrides = pkgs: {
    emojipick = pkgs-emojipick.emojipick.override {
      emojipick-font-size = "";
    };
  };

  environment.systemPackages = with pkgs; [
    emojipick
  ];
}
