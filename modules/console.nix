{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  #i18n.defaultLocale = "da_DK.UTF-8";
  fonts.fonts = with pkgs; [
    hasklig
  ];

  console = {
    font = "hasklig";
    keyMap = "dk";
  };
}
