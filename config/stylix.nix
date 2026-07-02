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
  };
}
