{ config, lib, pkgs, ...}:

let
  nord-wallpaper = lib.lists.elemAt (import ./misc/nord-wallpapers.nix {}) 0;
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
        package = pkgs.nordzy-cursor-theme;
      };
    };
  };
}
