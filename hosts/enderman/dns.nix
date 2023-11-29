{
  networking = {
    # my dns
    hosts = {
      "192.168.3.20" = [
        "jellyfin.northwing.games"
        "mc.northwing.games"
        "grocy.nortung.dk"
      ];
    };
    # ad blocking
    stevenBlackHosts.enable = true;

    nameservers = [
      # Mullvad adblock dns
      "194.242.2.3"
      # Mullvad dns
      "194.242.2.2"

      # Cloudflare
      "1.1.1.2"
      "1.0.0.2"

      # Google
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  services.dnsmasq = {
    enable = true;
    # settings = {
    #   port = 53;
    # };
    extraConfig = ''
      port=53
      # Never forward plain names (without a dot or domain part)
      domain-needed
      # Never forward addresses in the non-routed address spaces.
      bogus-priv
    '';
  };
}
