{
  inputs,
  config,
  ...
}: {
  mailserver = {
    enable = true;
    openFirewall = true;
    certificateScheme = 3;
    fqdn = "mails.northwing.games";
    domains = [ "northwing.games" "nortung.dk" ];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs#apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = {
      "admin@northwing.games" = {
        hashedPasswordFile = config.age.secrets.mail-pass-an.path;
      };
      "an@northwing.games" = {
        hashedPasswordFile = config.age.secrets.mail-pass-admin.path;
        aliases = ["alexander@northwing.games"];
      };
      "alexander@nortung.dk" = {
        hashedPasswordFile = config.age.secrets.mail-pass-admin.path;
      };
    };
  };
}
