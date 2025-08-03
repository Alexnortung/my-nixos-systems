let
  sshKeys = import ../../../config/ssh;
  keyFiles = sshKeys.deployers ++ [
    sshKeys.enderman
  ];
in
{
  "cross-seed.json.age".publicKeys = sshKeys.getKeys keyFiles;
  "minecraft-discord-bot-env.age".publicKeys = sshKeys.getKeys keyFiles;
}
