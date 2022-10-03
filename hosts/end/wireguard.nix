{ config, ... }:

{
  networking.nat.internalInterfaces = [ "end-poral" ];

  networking.wg-quick = {
    interfaces.end-portal = {
      address = [ "10.101.0.1/16" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wireguard-key.path;

      peers = [
        {
          # Enderman
          publicKey = "/zjnygUHf+HN+q4l6d1DmM4QlT/S8WzthkQruopWay4=";
          allowedIPs = [
            "10.101.0.2/32"
          ];
        }
        {
          # Boat
          publicKey = "XEU/FW0xYwrkDwbePbCKrTksv4OIMZD10IapbHPnRnc=";
          allowedIPs = [
            "10.101.0.3/32"
          ];
        }
        {
          # Phone
          publicKey = "fy/AY/PgKeUmiS36HvtIL2wpEGfXAIWJCczzJw2LaTQ=";
          allowedIPs = [
            "10.101.0.4/32"
          ];
        }
        {
          # Spider
          publicKey = "DhCnAsIFRWI1UA1b5tXnyid7oLaP5ZMR2OXVc8s6lEg=";
          allowedIPs = [
            "10.101.0.6/32"
          ];
        }
      ];
    };
  };
}
