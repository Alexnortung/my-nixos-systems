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
