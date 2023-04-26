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
    # enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    upstreams.enderman = {
      servers."10.101.0.2" = { };
    };

    streamConfig = ''
      server {
        listen 25565;
        listen 25565 udp;
        proxy_pass 10.101.0.2:25565;
      }

      # map $ssl_preread_server_name $targetBackend {
      #   jellyfin.northwing.games  10.101.0.2:443;
      # }
      #
      # server {
      #   listen 443;
      #
      #   proxy_connect_timeout 1s;
      #   proxy_timeout 3s;
      #   resolver 1.1.1.1;
      #   
      #   proxy_pass $targetBackend;
      #   ssl_preread on;
      # }
    '';
    virtualHosts = {
      # "jellyfin.northwing.games" = baseForwardSettings 8096;
      "jellyfin.northwing.games" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "0.0.0.0";
            port = 443;
            # ssl = true;
          }
          {
            addr = "[::0]";
            port = 443;
            # ssl = true;
          }
        ];
        locations."/" = {
          proxyPass = "$scheme://enderman$request_uri";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_ssl_server_name on;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
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
