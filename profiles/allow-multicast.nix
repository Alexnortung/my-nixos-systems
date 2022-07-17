# Use this to get Chromecast to work
{
  networking.firewall.extraCommands = ''
    iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
  '';
}
