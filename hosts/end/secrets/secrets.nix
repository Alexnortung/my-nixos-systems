let
  sshKeys = import ../../../config/ssh;
  keyFiles = sshKeys.deployers ++ [
    sshKeys.end
  ];
in
{
  # Edit with agenix -e <file>
  # For mail passwords, use a password hash from
  "wireguard-key.age".publicKeys = sshKeys.getKeys keyFiles;
  "mail-passwords/an-northwing.games.age".publicKeys = sshKeys.getKeys keyFiles;
  "mail-passwords/admin-northwing.games.age".publicKeys = sshKeys.getKeys keyFiles;
  "mail-passwords/bitwarden-northwing.games.age".publicKeys = sshKeys.getKeys keyFiles;
  "mail-passwords/mealie-nortung.dk.age".publicKeys = sshKeys.getKeys keyFiles;
  "nextcloud-admin-pass.age".publicKeys = sshKeys.getKeys keyFiles;
}
