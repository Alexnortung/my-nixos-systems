# Run a monero node
{
  networking.firewall.allowedTCPPorts = [ 18080 18081 ];

  services.monero = {
    enable = true;
    rpc = {
      restricted = true;
      address = "0.0.0.0";
    };

    extraConfig = ''
      confirm-external-bind=1
    '';
  };
}
