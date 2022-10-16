{ pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    # package = pkgs.mysql80;
    # dataDir = "/var/lib/mys1l80";
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions = {
          "nextcloud.*" = "ALL PRIVILEGES";
        };
      }
    ];

    ensureDatabases = [
      "nextcloud"
    ];
  };
}
