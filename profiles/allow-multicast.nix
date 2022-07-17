# Use this to get Chromecast to work
{
  networking.firewall.extraCommands = ''
    iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
    iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
    iptables -I INPUT -p udp -m udp --match multiport --dports 1900,5353 -j ACCEPT
  '';
  networking.firewall.allowedTCPPorts = [
    8008 8009 8010
  ];
  networking.firewall.allowedUDPPorts = [
    1900 # should be outbound
    5353
  ];
    #iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
}
