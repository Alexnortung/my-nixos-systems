let
  sshKeys = import ../../../config/ssh;
  spider = sshKeys.getKey sshKeys.spider;
  system = sshKeys.getKey sshKeys.spider_system;
in
{
  "wireguard-key.age".publicKeys = [ spider system ];
}
