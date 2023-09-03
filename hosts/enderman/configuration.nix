{ inputs
, config
, lib
, pkgs
, ...
}:
let
  system = "x86_64-linux";
  ssh-keys = import ../../config/ssh;
  authorizedKeyFiles = with ssh-keys; all;
in
{
  imports = [
    # Include the results of the hardware scan.
    ../../config/backup-bucket.nix
    ./hardware-configuration.nix
    ./secrets
    ./nginx.nix
    ./dns.nix
    ./gc.nix
    ./minecraft.nix
    ./grocy.nix
    ./home-assistant.nix
    # ./games.nix
    ../../modules/console.nix
    ../../modules/comfort-packages.nix
    ../../modules/personal-vpn.nix
    ../../profiles/registries.nix
  ];

  fileSystems."/data/data1" = {
    device = "/dev/disk/by-uuid/822601c9-fcec-444b-9703-e48f323ded12";
    mountPoint = "/data/data1";
    options = [
      "defaults"
      "noexec"
      "nouser"
      "rw"
    ];
  };

  fileSystems."/data/data2" = {
    device = "/dev/disk/by-uuid/561a42ce-2314-4c71-9a3b-795783863152";
    mountPoint = "/data/data2";
    options = [
      "defaults"
      "noexec"
      "nouser"
      "rw"
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];

  # Latest kernel to support NIC
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [
    "msr"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  networking = {
    hostName = "enderman"; # Define your hostname.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp2s0.useDHCP = true;

    nat.internalInterfaces = [ "wg0" ];

    networkmanager = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.agenix
    nmap
    git
    zip
    unzip
    wireguard-tools
    file
    curl
    #vim
    croc
    lm_sensors
    xmrig
    htop
    borgbackup
    mcrcon
    bashmount
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    openFirewall = true;
    banner = ''
       ,=====================.
       |  ENDERMAN           |
       |.-------------------.|
       ||[ _ o     . .  _ ]_||
       |`-------------------'|
       ||                   ||
       |`-------------------'|
       ||                   ||
       |`-------------------'|
       ||                   ||
       |`-----------------_-'|
       ||[=========]| o  (@) |
       |`---------=='/u\ --- |
       |------_--------------|
       | (/) (_)           []|
       |---==--==----------==|
       |||||||||||||||||||||||
       |||||||||||||||||||||||
       |||||||||||||||||||||||
       |||||||||||||||||||||||
       |||||||||||||||||||||||
       |||||||||||||||||||||||
       |||||||||||||||||dxm|||
       |||||||||||||||||||||||
       |=====================|
      .'                     `.
    '';

    settings = {
      PermitRootLogin = "without-password";
      PasswordAuthentication = false;
    };
  };

  users = {
    groups = {
      servarr = {
        gid = 998;
      };
    };
    users = {
      root.openssh.authorizedKeys.keyFiles = authorizedKeyFiles;
      #alexander = {
      #  openssh.authorizedKeys.keyFiles = authorizedKeyFiles;
      #  isNormalUser = true;
      #  shell = pkgs.zsh;
      #  extraGroups = [
      #    "wheel"
      #  ];
      #};
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    21
    22
    53 # dnsmasq
    50001
    51820 # wireguard
    5005 # testport
    8080 # this should be commected out when not in use
  ];
  networking.firewall.allowedUDPPorts = [
    53 # dnsmasq
    51820 # wireguard
  ];

  networking.wg-quick.interfaces = {
    end-portal = {
      address = [ "10.101.0.2/16" ];
      privateKeyFile = "/root/wireguard-keys/end-portal/wg-private";
    };
    wg-mullvad = {
      address = [ "10.64.28.12/32" ];
      # dns = [ "193.138.218.74" ]; # mullvad public dns
      dns = [ "10.64.0.1" ];
      privateKeyFile = "/root/wireguard-keys/mullvad/wg-mullvad";
      peers = [
        {
          publicKey = "7ncbaCb+9za3jnXlR95I6dJBkwL1ABB5i4ndFUesYxE=";
          allowedIPs = [ "10.8.0.1/32" "10.64.0.1/32" "10.124.0.0/22" ]; # Only send communication through mullvad if it is in the range of the given ips, allows for split tunneling
          endpoint = "176.125.235.74:3189";
        }
      ];
    };
  };

  # services.xserver = {
  #   enable = true;
  #   desktopManager.retroarch = {
  #     enable = true;
  #   };
  # };

  services.sonarr = {
    enable = true;
    group = "servarr";
    openFirewall = true;
    dataDir = "/data/data2/var/lib/sonarr/.config/NzbDrone";
  };

  services.radarr = {
    enable = true;
    group = "servarr";
    openFirewall = true;
    dataDir = "/data/data2/var/lib/radarr/.config/Radarr";
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.deluge = {
    enable = true;
    group = "servarr";
    openFirewall = true;
    dataDir = "/data/data1/var/lib/deluge/";
    # declarative = true;
    declarative = false;
    authFile = ../../config/misc/deluge-authfile.txt;
    config = {
      torrentfiles_location = "/data/data1/var/lib/deluge/torrent_files";
      download_location = "/data/data1/var/lib/deluge/Downloads";
      enabled_plugins = [
        "Label"
      ];
      max_active_seeding = 5;
      max_active_downloading = 25;
      max_active_limit = 30;
      queue_new_to_top = true;
      copy_torrent_file = true;
      pre_allocate_storage = true;
      proxy = {
        type = 2; # Socks5 I think
        hostname = "10.64.0.1"; # Use mullvad as proxy
        port = 1080;
        proxy_hostnames = true;
        proxy_tracker_connections = true;
        proxy_peer_connections = true;
        force_proxy = true;
        anonymous_mode = true;
      };
    };
    web = {
      enable = true;
      openFirewall = true;
    };
  };

  services.jellyfin = {
    enable = true;
    group = "servarr";
    openFirewall = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
