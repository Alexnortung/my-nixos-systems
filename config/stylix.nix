{ pkgs, ... }:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://images.hdqwalls.com/download/minimal-mountain-dark-5k-ur-2560x1440.jpg";
      hash = "sha256-LIqJnnsWxx+gl8dbdRRRLPdvhe/Itj32bIwxzGp6r5E=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    polarity = "dark";
  };
}
