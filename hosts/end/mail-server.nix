{
  inputs,
  config,
  ...
}:
{
  mailserver = {
    enable = true;
    openFirewall = true;
    certificateScheme = "acme-nginx";
    fqdn = "mails.northwing.games";
    domains = [
      "northwing.games"
      "nortung.dk"
    ];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs#apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = {
      "admin@northwing.games" = {
        hashedPasswordFile = config.age.secrets.mail-pass-an.path;
      };
      "bitwarden@northwing.games" = {
        hashedPasswordFile = config.age.secrets.mail-pass-bitwarden.path;
      };
      "an@northwing.games" = {
        hashedPasswordFile = config.age.secrets.mail-pass-admin.path;
        aliases = [ "alexander@northwing.games" ];
      };
      "alexander@nortung.dk" = {
        hashedPasswordFile = config.age.secrets.mail-pass-admin.path;
      };
    };

  };

  services.roundcube = {
    enable = true;
    hostName = "mails.northwing.games";
    extraConfig = ''
      # starttls needed for authentication, so the fqdn required to match
      # the certificate
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };
}
