{ pkgs, ... }:

{
  programs.eww = {
    enable = true;
    configDir = ../../../config/eww;
  };

  home.packages = with pkgs; [
    libnotify
  ];
}
