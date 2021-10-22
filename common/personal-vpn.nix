{
  networking.wg-quick.interfaces = {
    wg0 = {
      # set address on each system.
      # set privateKeyFile on each system.
      listenPort = 51820;
      peers = [
        {
          publicKey = "9WrHJEt/yzULE8IOLV0JkkA/8ult0RYg+buVuC7dfFU=";
          allowedIPs = [ "10.100.0.0/16" ]; # send all comunication to 10.100.x.x through wg0
          endpoint = "142.93.130.164:51820";
          persistentKeepalive = 25; # Keep nat tables alive
        }
      ];
    };
  };
}
