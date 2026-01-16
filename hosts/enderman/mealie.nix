{ config, ... }:

{
  services.mealie = {
    enable = false;
    database.createLocally = true;

    settings = {
      BASE_URL = "https://mealie.nortung.dk";
      TZ = "Europe/Copenhagen";

      SMTP_HOST = "mails.northwing.games";
      SMTP_USER = "mealie@nortung.dk";
      SMTP_FROM_EMAIL = "mealie@nortung.dk";
    };

    credentialsFile = config.age.secrets.mealie-credentials.path;
  };

  networking.firewall.allowedTCPPorts = [ 9000 ];
}
