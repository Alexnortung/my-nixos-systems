{ config, lib, pkgs, ...}:

let
  pkgs-cursor = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/pull/150322/merge";
    rev = "5a6e995a46ccb5e16c3c7ddba700c8d753b8ae41";
  }) { };
in
{
  services.xserver.displayManager.lightdm = {
    greeters.gtk = {
      enable = true;
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
      cursorTheme = {
        name = "Nordzy-white-cursors";
        package = pkgs-cursor.nordzy-cursor-theme;
      };
    };
  };
}