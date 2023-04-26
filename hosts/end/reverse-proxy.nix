{ ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@northwing.games";

    # certs = {
    #   "bitwarden.northwing.games" = {};
    #   "nextcloud.northwing.games" = {};
    #   "mails.northwing.games" = {};
    # };
  };

  networking.firewall.allowedTCPPorts = [
    80 443
  ];

  # services.caddy = {
  #   enable = true;
  #
  #   virtualHosts = {
  #     "bitwarden.northwing.games" = {
  #       extraConfig = ''
  #         reverse_proxy / :8812
  #         reverse_proxy /notifications/hub :3012
  #         reverse_proxy /notifications/hub/negotiate :8812
  #       '';
  #     };
  #   };
  # };
}
