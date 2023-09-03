{ pkgs, lib, ... }: {
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

  services.phpfpm.pools.grocy = {
    phpPackage = lib.mkForce pkgs.php82;
  };
}
