{ pkgs, ... }:
let
  namespace = "vpn-services";
  namespacePath = "/run/netns/${namespace}";
  namespaceAddress = "10.200.0.2";
  wireguardPeerService = "wireguard-wg-mullvad-peer-mullvad.service";

  vpnService = {
    after = [ wireguardPeerService ];
    requires = [ wireguardPeerService ];
    serviceConfig = {
      NetworkNamespacePath = namespacePath;
      BindReadOnlyPaths = [ "/etc/netns/${namespace}/resolv.conf:/etc/resolv.conf" ];
    };
  };
in
{
  environment.etc."netns/${namespace}/resolv.conf".text = ''
    nameserver 193.138.218.74
  '';

  systemd.services.vpn-services-netns = {
    description = "Network namespace for VPN-routed services";
    before = [ "wireguard-wg-mullvad.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.iproute2 ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ip netns add ${namespace}
      ip link add vpn-host type veth peer name vpn-services
      ip link set vpn-services netns ${namespace}

      ip address add 10.200.0.1/30 dev vpn-host
      ip link set vpn-host up

      ip -n ${namespace} address add ${namespaceAddress}/30 dev vpn-services
      ip -n ${namespace} link set lo up
      ip -n ${namespace} link set vpn-services up
    '';
    preStop = ''
      ip netns delete ${namespace}
    '';
  };

  # The encrypted UDP socket stays in the host namespace while the tunnel
  # interface and its default route are moved into the service namespace.
  networking.wireguard.interfaces.wg-mullvad = {
    ips = [ "10.64.28.12/32" ];
    privateKeyFile = "/root/wireguard-keys/mullvad/wg-mullvad";
    interfaceNamespace = namespace;
    peers = [
      {
        name = "mullvad";
        # se-got-005
        publicKey = "x4h55uXoIIKUqKjjm6PzNiZlzLjxjuAIKzvgU9UjOGw=";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "185.209.199.2:51820";
      }
    ];
  };

  systemd.services.wireguard-wg-mullvad = {
    after = [ "vpn-services-netns.service" ];
    requires = [ "vpn-services-netns.service" ];
  };

  systemd.services.jellyfin = vpnService;
  systemd.services.deluged = vpnService;
  systemd.services.delugeweb = vpnService;
  systemd.services.cross-seed = vpnService;

  networking.firewall.allowedTCPPorts = [
    2468
    8096
  ];

  systemd.sockets.jellyfin-proxy = {
    description = "Host socket for Jellyfin in the VPN namespace";
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "8096" ];
  };

  systemd.services.jellyfin-proxy = {
    description = "Proxy host connections to Jellyfin in the VPN namespace";
    after = [ "jellyfin.service" ];
    requires = [ "jellyfin.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 127.0.0.1:8096";
      NetworkNamespacePath = namespacePath;
      PrivateTmp = true;
    };
  };

  systemd.sockets.deluge-web-proxy = {
    description = "Host socket for Deluge Web in the VPN namespace";
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "8112" ];
  };

  systemd.services.deluge-web-proxy = {
    description = "Proxy host connections to Deluge Web in the VPN namespace";
    after = [ "delugeweb.service" ];
    requires = [ "delugeweb.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 127.0.0.1:8112";
      NetworkNamespacePath = namespacePath;
      PrivateTmp = true;
    };
  };

  systemd.sockets.cross-seed-proxy = {
    description = "Host socket for Cross-seed in the VPN namespace";
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "2468" ];
  };

  systemd.services.cross-seed-proxy = {
    description = "Proxy host connections to Cross-seed in the VPN namespace";
    after = [ "cross-seed.service" ];
    requires = [ "cross-seed.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 127.0.0.1:2468";
      NetworkNamespacePath = namespacePath;
      PrivateTmp = true;
    };
  };
}
