{
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@northwing.games";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443 # HTTP and HTTPS
  ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "jellyfin.northwing.games" = {
        # forceSSL = true;
        enableACME = true;
        addSSL = true;
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:8096";
          # return = "301 https://google.com";
          extraConfig = ''
            # proxy_set_header Host $host;
            # proxy_set_header X-Real-IP $remote_addr;
            # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            # proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };
}
