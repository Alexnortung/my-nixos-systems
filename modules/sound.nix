{ config, ... }:

{
  # Enable sound.
  services.pulseaudio = {
    enable = true;
    #systemWide = true;
    support32Bit = true;
    tcp = {
      enable = false;
      anonymousClients = {
        allowedIpRanges = [
          "127.0.0.1"
          "192.168.7.0/24"
        ];
      };
    };
  };

  environment.systemPackages = [
    config.services.pulseaudio.package
  ];
  # nixpkgs.config.pulseaudio = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #};

}
