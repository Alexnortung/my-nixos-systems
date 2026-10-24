{ config, ... }:

{
  networking.firewall.allowedUDPPorts = [
    51821 # wireguard (end-gate)
  ];

  # Forward Minecraft to the end-gate peer. Masquerade so replies route back
  # through end regardless of the peer's routing.
  networking.nat.extraCommands = ''
    iptables -w -t nat -A nixos-nat-pre -m addrtype --dst-type LOCAL -p tcp --dport 25566 -j DNAT --to-destination 10.102.0.2:25565
    iptables -w -t nat -A nixos-nat-post -o end-gate -d 10.102.0.2 -p tcp --dport 25565 -j MASQUERADE
    iptables -w -t filter -A nixos-filter-forward -o end-gate -d 10.102.0.2 -p tcp --dport 25565 -j ACCEPT
  '';

  networking.wg-quick.interfaces.end-gate = {
    address = [ "10.102.0.1/24" ];
    listenPort = 51821;
    privateKeyFile = config.age.secrets.wireguard-key.path;

    peers = [
      {
        publicKey = "6EdKNMUJrrb99YonjI8z1y7XT2gLdS9oMfrZGYBtTmg=";
        allowedIPs = [
          "10.102.0.2/32"
        ];
      }
    ];
  };
}
