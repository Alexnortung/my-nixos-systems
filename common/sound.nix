{ config, ... }:

{
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    systemWide = true;
    support32Bit = true;
    #tcp = { enable = true; anonymousClients = { allowedIpRanges = ["127.0.0.1" "192.168.7.0/24"]; }; };
  };
}
