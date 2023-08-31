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

    upstreams.enderman = {
      servers."10.101.0.2" = { };
    };

    streamConfig = ''
      upstream endermanSsl {
        server 10.101.0.2:443;
      }

      upstream localSsl {
        server 127.0.0.1:8443;
      }

      server {
        listen 25565;
        listen 25565 udp;
        proxy_pass 10.101.0.2:25565;
      }

      map $ssl_preread_server_name $targetBackend {
        jellyfin.northwing.games  endermanSsl;
        mails.northwing.games     localSsl;
        nextcloud.northwing.games localSsl;
        bitwarden.northwing.games localSsl;
      }

      server {
        listen 443;

        proxy_connect_timeout 1s;
        proxy_timeout 3s;
        # resolver 1.1.1.1;
        
        proxy_pass $targetBackend;
        # proxy_pass 10.101.0.2:443;
        # proxy_pass endermanSsl;
        ssl_preread on;
      }
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
            port = 8443;
            ssl = true;
          }
          # {
          #   addr = "[::0]";
          #   port = 443;
          #   # ssl = true;
          # }
        ];
        locations."/" = {
          proxyPass = "$scheme://enderman$request_uri";
          proxyWebsockets = true;
          extraConfig = ''
            # proxy_ssl_server_name on;
            # proxy_set_header Host $host;
            # proxy_set_header X-Real-IP $remote_addr;
            # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            # proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
      # "nextcloud.northwing.games" = baseForwardSettings 3005;
      "nextcloud.northwing.games" = {
        forceSSL = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "0.0.0.0";
            port = 8443;
            ssl = true;
          }
        ];
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3005";
        };
      };
      "mails.northwing.games" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "0.0.0.0";
            port = 8443;
            ssl = true;
          }
        ];
      };
      "bitwarden.northwing.games" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "0.0.0.0";
            port = 8443;
            ssl = true;
          }
        ];
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
    };
  };
}
