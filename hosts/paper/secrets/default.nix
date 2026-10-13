{ config, ... }:
{
  # paper does not run sshd, so point agenix at the host key explicitly
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  age.secrets = {
    "dok3.conf".file = ./dok3.conf.age;
  };

  networking.wg-quick.interfaces.dok3 = {
    configFile = config.age.secrets."dok3.conf".path;
  };
}
