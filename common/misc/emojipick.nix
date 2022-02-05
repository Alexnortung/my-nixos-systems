{ pkgs, ... }:

let
  pkgs-emojipick = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/pull/158187/merge";
    rev = "2325a754e19e40b227b50323acfedca41836fbf9";
  }) {};
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
