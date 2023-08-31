let
  nginxConfig = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:8812"; #changed the default rocket port due to some conflict
      proxyWebsockets = true;
    };
    locations."/notifications/hub" = {
      proxyPass = "http://localhost:3012";
      proxyWebsockets = true;
    };
    locations."/notifications/hub/negotiate" = {
      proxyPass = "http://localhost:8812";
      proxyWebsockets = true;
    };
  };
in
{
  networking.firewall.allowedTCPPorts = [
    3012 # vaultwarden websockets
  ];
  services.vaultwarden = {
    enable = true;
    config = {
      rocketPort = 8812;
      websocketsEnabled = true;
      signupsAllowed = true;
      # adminToken = "";
      #websocketPort = 3012;
    };
  };

  # services.nginx.virtualHosts."bitwarden.northwing.games" = nginxConfig;
  # services.nginx.virtualHosts."bitwarden2.northwing.games" = nginxConfig;

}
