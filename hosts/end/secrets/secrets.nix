let
  sshKeys = import ../../../config/ssh;
  keyFiles = sshKeys.deployers ++ [
    sshKeys.end
  ];
in
{
  "wireguard-key.age".publicKeys = sshKeys.getKeys keyFiles;
  "mail-passwords/an-northwing.games.age".publicKeys = sshKeys.getKeys keyFiles;
  "mail-passwords/admin-northwing.games.age".publicKeys = sshKeys.getKeys keyFiles;
}
