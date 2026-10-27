{ pkgs, ... }:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/dharmx/walls/main/flowers/a_group_of_flowers_in_a_vase.jpg";
      hash = "sha256-49dEbVxRzegiRx2LyExX9EPjW0VxKH8K7ZpkiaGjR8w=";
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
