{ config, lib, pkgs, ...}:

let
  nord-wallpaper = (builtins.fetchurl {
    url = "https://nordthemewallpapers.com/Backgrounds/All/img/daniel-leone-v7daTKlZzaw-unsplash%20[modded].jpg";
    name = "nord-wallpaper-v7daTKlZzaw";
  });
  pkgs-cursor = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/pull/150322/merge";
    rev = "5a6e995a46ccb5e16c3c7ddba700c8d753b8ae41";
  }) { };
in
{
  services.xserver.displayManager.lightdm = {
    background = nord-wallpaper;
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
