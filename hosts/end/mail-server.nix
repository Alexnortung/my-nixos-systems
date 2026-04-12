{
  inputs,
  pkgs,
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
      "morgan@nortung.dk" = {
        hashedPasswordFile = config.age.secrets.mail-pass-morgan.path;
      };
      "mealie@nortung.dk" = {
        hashedPasswordFile = config.age.secrets.mail-pass-mealie.path;
      };
    };

    stateVersion = 3;
  };

  services.roundcube = {
    enable = true;
    hostName = "mails.northwing.games";
    package = pkgs.roundcube.withPlugins (
      plugins: with plugins; [
        # external plugins to be included
        # https://search.nixos.org/packages?query=roundcubePlugins
        persistent_login
      ]
    );
    # activate plugins
    plugins = [
      "persistent_login"
      "managesieve" # built-in
    ];
    dicts = with pkgs.aspellDicts; [
      # https://search.nixos.org/packages?query=aspellDicts
      en
    ];
    maxAttachmentSize = config.mailserver.messageSizeLimit / 1024 / 1024;
    extraConfig = ''
      $config['imap_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";

      $config['managesieve_host'] = "tls://${config.mailserver.fqdn}";
      $config['managesieve_port'] = 4190;
      $config['managesieve_usetls'] = true;
    '';
  };
}
