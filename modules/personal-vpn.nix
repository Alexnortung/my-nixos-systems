{
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.wireguard.enable = true;

  networking.firewall.allowedUDPPorts = [
    51820
    51821
  ];

  networking.wg-quick.interfaces = {
    end-portal = {
      # set address on each system.
      # set privateKeyFile on each system.
      listenPort = 51820;
      peers = [
        {
          publicKey = "/nLRKleGr1CTmoe76TLPJ45uHUORsPza4/OSpW4Zmjk=";
          allowedIPs = [ "10.101.0.0/16" ]; # send all comunication to 10.101.x.x through wg0
          # endpoint = "142.93.130.164:51820";
          endpoint = "86.48.0.131:51820";
          persistentKeepalive = 25; # Keep nat tables alive
        }
      ];
    };
    wg0 = {
      # set address on each system.
      # set privateKeyFile on each system.
      listenPort = 51821;
      peers = [
        {
          publicKey = "9WrHJEt/yzULE8IOLV0JkkA/8ult0RYg+buVuC7dfFU=";
          allowedIPs = [ "10.100.0.0/16" ]; # send all comunication to 10.100.x.x through wg0
          endpoint = "142.93.130.164:51820";
          # endpoint = "86.48.0.131:51820";
          persistentKeepalive = 25; # Keep nat tables alive
        }
      ];
    };
  };
}
