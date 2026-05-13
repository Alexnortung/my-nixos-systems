{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  services.grocy = {
    enable = true;
    hostName = "grocy.nortung.dk";
    nginx = {
      enableSSL = true;
    };

    settings = {
      currency = "DKK";
      culture = "da";
    };
  };
}
