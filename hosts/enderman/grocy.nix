{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
  };
in
{
  services.grocy = {
    enable = true;
    hostName = "grocy.nortung.dk";
    package = unstable.grocy;
    nginx = {
      enableSSL = true;
    };

    settings = {
      currency = "DKK";
      culture = "da";
    };
  };

  services.phpfpm.pools.grocy = {
    phpPackage = lib.mkForce pkgs.php82;
  };
}
