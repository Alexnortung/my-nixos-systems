let
  sshKeys = import ../ssh;
  keyFiles = sshKeys.deployers ++ [
    sshKeys.end
    sshKeys.enderman
  ];
in
{
  "backup-1-credentials.age".publicKeys = sshKeys.getKeys keyFiles;
}
