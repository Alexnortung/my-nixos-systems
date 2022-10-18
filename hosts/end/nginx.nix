{lib, ...}: let
  baseForwardSettings = port: {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      # TODO: use variable for host or implement local dns
      proxyPass = "http://10.101.0.2:${builtins.toString port}";
    };
  };
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@northwing.games";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443 # HTTP and HTTPS
    25565 # Minecraft
  ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    streamConfig = ''
      server {
        listen 25565;
        listen 25565 udp;
        proxy_pass 10.101.0.2:25565;
      }
    '';
    virtualHosts = {
      "jellyfin.northwing.games" = baseForwardSettings 8096;
      # "nextcloud.northwing.games" = baseForwardSettings 3005;
      "nextcloud.northwing.games" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3005";
        };
      };
      # "mc.northwing.games" = baseForwardSettings 25565;
    };
  };
}
