let
  sshKeys = import ../../../config/ssh;
  keyFiles = sshKeys.deployers ++ [
    sshKeys.enderman
  ];
in
{
  "minecraft-discord-bot-env.age".publicKeys = sshKeys.getKeys keyFiles;
}
