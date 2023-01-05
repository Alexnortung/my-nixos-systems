{ config, ... }:

{
  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "nextcloud.northwing.games";
    config = {
      adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
      dbtype = "sqlite";
      # dbtype = "mysql";
      # dbport = 3306;
    };
  };
}
