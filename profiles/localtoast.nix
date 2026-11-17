{ ... }:

{
  networking.hosts = {
    "127.0.0.1" = [ "localtoast" ];
    "::1" = [ "localtoast" ];
  };
}
