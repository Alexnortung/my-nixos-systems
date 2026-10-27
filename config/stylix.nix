{ pkgs, ... }:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/dharmx/walls/blob/main/minimal/a_drawing_of_a_bear_and_a_campfire.png?raw=true";
      hash = "sha256-GVam71y9Lvdmq1YWhlnZVba3CuuttnUr8PCwh0hk5pM=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
    polarity = "dark";

    fonts = {
      # Monospace stays on Stylix's default (DejaVu Sans Mono); icons come
      # from the system-wide Symbols Nerd Font fallback.
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      sizes = {
        desktop = 11;
        popups = 12;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    opacity = {
      terminal = 0.92;
      popups = 0.95;
    };
  };
}
