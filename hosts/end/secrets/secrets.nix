let
  sshKeys = import ../../../config/ssh;
  keyFiles = sshKeys.deployers ++ [
    sshKeys.end
  ];
in
{
  "wireguard-key.age".publicKeys = sshKeys.getKeys keyFiles;
}
