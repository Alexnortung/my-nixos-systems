{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  system = "x86_64-linux";
  ssh-keys = import ../../config/ssh;
  authorizedKeyFiles = with ssh-keys; all;
  unstable = import inputs.nixpkgs-unstable { inherit inputs system; };
in
{
  imports = [
    # Include the results of the hardware scan.
    # ../../config/backup-bucket.nix
    ./hardware-configuration.nix
    ./secrets
    ./audiobookshelf.nix
    ./nginx.nix
    ./dns.nix
    ./factorio.nix
    ./gc.nix
    ./minecraft
    ./mealie.nix
    ./grocy.nix
    # ./home-assistant.nix
    # ./games.nix
    ../../modules/console.nix
    ../../modules/comfort-packages.nix
    ../../modules/personal-vpn.nix
    # ../../profiles/registries.nix
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
  time.hardwareClockInLocalTime = true;

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
      # enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    tmux
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

      readarr = {
        isNormalUser = false;
        createHome = false;
        group = "servarr";
        uid = 986;
      };
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

    8787 # Readarr
    64422 # deluge
  ];
  networking.firewall.allowedUDPPorts = [
    53 # dnsmasq
    51820 # wireguard
    64422 # deluge
  ];

  networking.wg-quick.interfaces = {
    end-portal = {
      address = [ "10.101.0.2/16" ];
      privateKeyFile = "/root/wireguard-keys/end-portal/wg-private";
    };
    wg-mullvad = {
      address = [ "10.64.28.12/32" ];
      # dns = [ "193.138.218.74" ]; # mullvad public dns
      # dns = [ "10.64.0.1" ];
      privateKeyFile = "/root/wireguard-keys/mullvad/wg-mullvad";
      peers = [
        {
          # se-got-004
          publicKey = "veGD6/aEY6sMfN3Ls7YWPmNgu3AheO7nQqsFT47YSws=";
          allowedIPs = [
            "10.8.0.1/32"
            "10.64.0.1/32"
            "10.124.0.0/22"
          ]; # Only send communication through mullvad if it is in the range of the given ips, allows for split tunneling
          endpoint = "185.213.154.69:51820";
        }
        {
          # se-got-005
          publicKey = "x4h55uXoIIKUqKjjm6PzNiZlzLjxjuAIKzvgU9UjOGw=";
          allowedIPs = [
            "10.8.0.1/32"
            "10.64.0.1/32"
            "10.124.0.0/22"
          ]; # Only send communication through mullvad if it is in the range of the given ips, allows for split tunneling
          endpoint = "185.209.199.2:51820";
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
  # Save a file to etc directory
  environment.etc = {
    "arr-on-import-symlink.sh" = {
      enable = true;
      group = "servarr";
      # source = ./scripts/arr-on-import-symlink.sh;
      mode = "0555";
      source = pkgs.writeShellScript "arr-on-import-symlink.sh" (
        builtins.readFile ./scripts/arr-on-import-symlink.sh
      );
    };
  };

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

  # services.readarr = {
  #   enable = true;
  #   package = unstable.readarr;
  #   group = "servarr";
  #   openFirewall = true;
  #   dataDir = "/data/data2/var/lib/readarr/.config/Readarr";
  # };

  services.prowlarr = {
    enable = true;
    package = unstable.prowlarr;
    openFirewall = true;
  };

  services.deluge = {
    enable = true;
    group = "servarr";
    openFirewall = true;
    dataDir = "/data/data1/var/lib/deluge/";
    # declarative = true;
    declarative = false;
    # authFile = ../../config/misc/deluge-authfile.txt;
    config = {
      torrentfiles_location = "/data/data1/var/lib/deluge/torrent_files";
      download_location = "/data/data1/var/lib/deluge/Downloads";
      enabled_plugins = [
        "Label"
      ];
      max_active_seeding = 30;
      max_active_downloading = 35;
      max_active_limit = 60;
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

  services.cross-seed = {
    enable = true;
    useGenConfigDefaults = true;
    user = "deluge";
    group = "servarr";
    settings = {
      linkDirs = [
        "/data/data1/var/lib/deluge/cross-seed-links"
      ];
      dataDirs = [
        "/data/data1/var/lib/deluge/Downloads"
        "/data/data1/var/lib/radarr/movies"
        "/data/data1/var/lib/sonarr/series"
      ];
      # torrentDir = "/data/data1/var/lib/deluge/.config/deluge/state";
      # useClientTorrents = false;
      useClientTorrents = true;
      outputDir = "/data/data1/var/lib/deluge/output";
      linkType = "hardlink";
      matchMode = "partial";
      skipRecheck = true;
      maxDataDepth = 3;
      # includeSingleEpisodes = true;
      # seasonFromEpisodes = 0.5;
      fuzzySizeThreshold = 0.02;
      action = "inject";
      duplicateCategories = true;
    };
    settingsFile = config.age.secrets.cross-seed-config.path;
  };

  services.jellyfin =
    let
      jellyfin-pkgs = import inputs.nixpkgs-jellyfin { inherit inputs system; };
    in
    {
      enable = true;
      group = "servarr";
      openFirewall = true;
      package = jellyfin-pkgs.jellyfin;
    };

  virtualisation = {
    docker = {
      enable = true;
    };

    oci-containers = {
      backend = "docker";
      containers = {
        # flaresolverr = {
        #   image = "ghcr.io/flaresolverr/flaresolverr:latest";
        #   ports = [ "8191:8191" ];
        #   environment = {
        #     LOG_LEVEL = "info";
        #   };
        # };
        bookshelf = {
          image = "ghcr.io/pennydreadful/bookshelf:hardcover-v0.4.20.91";
          ports = [ "8787:8787" ];
          # user = "readarr:servarr";
          user = "986:998";
          volumes = [
            "/data/data2/var/lib/bookshelf/.config/bookshelf:/config"
            "/data/data1/var/lib/readarr/books/:/data/data1/var/lib/readarr/books/"
            "/data/data1/var/lib/deluge/Downloads:/data/data1/var/lib/deluge/Downloads"

            "/etc/passwd:/etc/passwd:ro"
            "/etc/group:/etc/group:ro"
          ];
          networks = [ "host" ];
        };
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
