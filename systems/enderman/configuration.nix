# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  # pass config so that packages use correct allowUnfree for example
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/465daf79b4a23d6e47d2efddece7120da8800c63.tar.gz";
    sha256 = "0yp8dacjhm632zk6wbiqx69j5xrqz29mvp7cdn2l3asxs0cf85vs";
  };
  unfreeConfig = config.nixpkgs.config // {
    allowUnfree = true;
  };
  pkgs-xmrig = import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify                
      name = "xmrig-rev";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "860b56be91fb874d48e23a950815969a7b832fbc";
  }) {};
  pkgs-papermc-1-17-1= import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify                
      name = "papermc-1-17-1-rev";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "08ef0f28e3a41424b92ba1d203de64257a9fca6a";
  }) { config = unfreeConfig; };                                                                           
  pkgs-sonarr = import (builtins.fetchGit {
    name = "sonarr-revision";
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "860b56be91fb874d48e23a950815969a7b832fbc";
  }) {};
  pkgs-jellyfin = import (builtins.fetchGit {
    name = "jellyfin-revision";
    url = "https://github.com/nixos/nixpkgs/";
    #ref = "refs/heads/nixpkgs-unstable";
    rev = "8a2ec31e224de9461390cdd03e5e0b0290cdad0b";
  }) {};
  nixos-unstable = builtins.fetchGit {
    name = "nixos-unstable";
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixos-unstable";
    rev = "34ad3ffe08adfca17fcb4e4a47bb5f3b113687be";
  };
  nixos-unstable-imported = import nixos-unstable {};
  authorizedKeyFiles = [
    /etc/nixos/ext-conf/.ssh/authorizedKeys
    /etc/nixos/ext-conf/.ssh/authorizedKeysFolder/alexander_boat.pub
  ];
in
{
  nix.nixPath = [
    "nixpkgs=${nixpkgs}"
    "nixos-config=/etc/nixos/configuration.nix"
  ];
  nixpkgs.config = {
    packageOverrides = pkgs: {
      sonarr = pkgs-sonarr.sonarr;
      prowlarr = nixos-unstable-imported.prowlarr;
    };
  };

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

  imports =
    [ # Include the results of the hardware scan.
      "${nixos-unstable}/nixos/modules/services/misc/prowlarr.nix"
      ../../common/nvim.nix
      ../../common/console.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];

  networking.hostName = "enderman"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #networking.nat.enable = true;
  #networking.nat.externalInterface = "enp0s31f6";
  networking.nat.internalInterfaces = [ "wg0" ];

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  environment.systemPackages = with pkgs; [
    nmap
    git
    zip unzip
    wireguard
    file
    curl
    vim
    croc
    lm_sensors
    pkgs-xmrig.xmrig
    htop
    borgbackup
    mcrcon
    bashmount
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    openFirewall = true;
    permitRootLogin = "without-password";
    passwordAuthentication = false;
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
  };
  
  users = {
    groups = {
      servarr = {};
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
    #25565
    #25575 # mc rcon
    50001
    51820 # wireguard
    5005 # testport
    8080 # this should be commected out when not in use
  ];
  networking.firewall.allowedUDPPorts = [
    #25565
    51820 # wireguard
  ];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.100.0.2/16" ];
      listenPort = 51820; 
      privateKeyFile = "/root/wireguard-keys/wg-private";
      peers = [
        {
          publicKey = "9WrHJEt/yzULE8IOLV0JkkA/8ult0RYg+buVuC7dfFU=";
          allowedIPs = [ "10.100.0.0/16" ]; # send all communication to 10.100.xxx.xxx through wg0
          endpoint = "142.93.130.164:51820";
          persistentKeepalive = 25; # make sure nat tables are always fresh
        }
      ];
    };
    wg-mullvad = {
      address = [ "10.64.156.180/32" "fc00:bbbb:bbbb:bb01::1:9cb3/128" ];
      dns = [ "193.138.218.74" ]; # mullvad public dns
      privateKeyFile = "/root/wireguard-keys/mullvad/wg-mullvad";
      peers = [
        {
          publicKey = "E3XgsLAaDdRhYl5tPbBIO87bdTYQmpF72nqIhFBk3g8=";
          allowedIPs = [ "10.64.0.1/32" "10.124.0.0/22" ]; # Only send communication through mullvad if it is in the range of the given ips, allows for split tunneling
          endpoint = "176.125.235.72:3319";
        }
      ];
    };
  };

  services.sonarr = {
    enable = true;
    group = "servarr";
    openFirewall = true;
    #dataDir = "/var/lib/sonarr";
  };

  services.radarr = {
    enable = true;
    group = "servarr";
    openFirewall = true;
    #dataDir = "/var/lib/radarr";
  };

  services.lidarr = {
    enable = true;
    group = "servarr";
    openFirewall = true;
    #dataDir = "/var/lib/radarr";
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
    declarative = true;
    authFile = /etc/nixos/ext-conf/deluge/deluge-auth;
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
    package = pkgs-jellyfin.jellyfin;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "minecraft-server"
  ];

  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    package = pkgs-papermc-1-17-1.papermc;
    dataDir = "/data/data1/var/lib/minecraft";
    openFirewall = true;
    serverProperties = {
      server-ip = "0.0.0.0";
      #server-ip = "10.100.0.2";
      enable-query = false;
      enable-jmx-monitoring = false;
      motd = "Hi!";
      "query.port" = 25565;
      texture-pack = "";
      network-compression-threshold = 256;
      rate-limit = 0;
      max-tick-time = -1;
      require-resource-pack = false;
      resource-pack-sha1 = "";
      generator-settings = "";
      use-native-transport = true;
      enable-status = true;
      level-seed = "-4846211776141860780";
      enable-command-block = false;
      gamemode = "survival";
      force-gamemode = false;
      level-name = "world";
      pvp = true;
      generate-structures = true;
      difficulty = "normal";
      max-players = 10;
      online-mode = true;
      allow-flight = false;
      view-distance = 10;
      max-build-height = 256;
      allow-nether = true;
      server-port = 25565;
      op-permission-level = 4;
      player-idle-timeout = 0;
      debug = false;
      hardcore = false;
      white-list = true;
      broadcast-console-to-ops = true;
      boradcast-rcon-to-ops = true;
      spawn-npcs = true;
      spawn-animals = true;
      snooper-enabled = true;
      text-filtering-config = "";
      function-permission-level = 2;
      level-type = "default";
      spawn-monsters = true;
      spawn-protection = 16;
      max-world-size = 29999984;
      sync-chunk-writes = true;
      enable-rcon = false;
      "rcon.port"=25575;
      prevent-proxy-connection = false;
      entity-broadcast-range-percentage = 100;
      
    };
    whitelist = {
      Yamse = "a09863fd-d715-4838-a8c2-e93be9eceb7c";
      Nollefyr = "94553a27-7088-4bc6-8c33-ad1fd79b591b";
      isso55 = "5dd48794-78f4-4beb-8eca-4b4bd7dcb0c5";
      Mokkamussen = "f893734b-534c-4321-bb91-6eeb662c01ed";
      Null_Boi = "e9fdc0f4-7c45-406d-a2bc-34d059687c22";
      Nanna4478 = "c493e333-ed41-4b29-aef5-4949291faf3b";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

