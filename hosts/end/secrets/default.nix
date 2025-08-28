{
  imports = [
    ../../../config/secrets
  ];

  age.secrets = {
    wireguard-key.file = ./wireguard-key.age;
    mail-pass-an.file = ./mail-passwords/an-northwing.games.age;
    mail-pass-admin.file = ./mail-passwords/an-northwing.games.age;
    mail-pass-bitwarden.file = ./mail-passwords/bitwarden-northwing.games.age;
    mail-pass-mealie.file = ./mail-passwords/mealie-nortung.dk.age;
    # nextcloud-admin-pass = {
    #   file = ./nextcloud-admin-pass.age;
    #   mode = "440";
    #   owner = "root";
    #   group = "nextcloud";
    # };
  };
}
