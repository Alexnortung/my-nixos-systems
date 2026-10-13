let
  sshKeys = import ../../../config/ssh;
  paper = sshKeys.getKey sshKeys.paper;
  system = sshKeys.getKey sshKeys.paper_system;
in
{
  "dok3.conf.age".publicKeys = [ paper system ];
}
