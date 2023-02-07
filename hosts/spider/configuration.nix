# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs
, config
, lib
, inputs
, ...
}:
let
  system = "x86_64-linux";
  slock-command = "/run/wrappers/bin/slock";
  unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
in
{
  imports = [
    ./hardware-configuration.nix
    ./secrets
    ../../modules/personal-vpn.nix
    ../../modules/programming-pkgs.nix
    ../../modules/comfort-packages.nix
    ../../modules/sound.nix
    ../../modules/console.nix
    # ../../modules/vscodium.nix
    # ../../modules/latex.nix
    ../../modules/nord-lightdm.nix
    ../../modules/nord-gtk.nix
    ../../modules/basic-desktop.nix
    ../../modules/zsh.nix
    ../../modules/location-denmark.nix
    ../../profiles/allow-multicast.nix
    ../../profiles/registries.nix
  ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_rsa_key"
    "/home/alexander/.ssh/id_rsa"
  ];

  # networking.wg-quick.interfaces.wg0 = {
  #   privateKeyFile = config.age.secrets.wireguard-key.path;
  #   address = [ "10.100.0.6/32" ];
  # };
  networking.wg-quick.interfaces.end-portal = {
    privateKeyFile = config.age.secrets.wireguard-key.path;
    address = [ "10.101.0.6/32" ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.nix-ld.enable = true;

  programs.steam.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [
        "root"
        "alexander"
      ];
    };
    # extraOptions = ''
    #   experimental-features = nix-command flakes
    # '';
  };

  hardware.bluetooth = {
    enable = true;
  };

  # swapDevices = [
  #   {
  #     label = "swap";
  #   }
  # ];

  fonts.fonts = with pkgs; [
    hasklig
    terminus-nerdfont
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        version = 2;
        configurationLimit = 25;
        devices = [ "nodev" ];
        enable = true;
        efiSupport = true;
      };
      # systemd-boot = {
      #   enable = true;
      # };
    };
    # Boot animation
    plymouth = {
      enable = false;
      theme = "solar";
      extraConfig = ''
        ShowDelay=0
      '';
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "spider";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
    networkmanager = {
      enable = true;
    };
    wireguard = {
      enable = true;
    };
    firewall = {
      enable = false;
      checkReversePath = lib.mkForce "loose";
      allowedTCPPorts = [
        3000 # dev
        8008
        8009 # Chromecast
        1337
      ];
      allowedUDPPorts = [
        3000 # dev
        32768
        61000 # Chromecast
        51820 # wireguard
      ];
    };
    extraHosts = ''
      192.168.49.2 minikube
      192.168.49.2 oak-site-backend.minikube
      192.168.49.2 oak-site-frontend.minikube
    '';
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # services.openssh.enable = true;

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns = true;
  };
  # for a WiFi printer

  services.batteryNotifier = {
    enable = true;
    notifyCapacity = 15;
    hibernateCapacity = 5;
  };

  services.bg-setter = {
    enable = true;
    wallpaper = lib.lists.elemAt (import ../../config/misc/nord-wallpapers.nix { }) 0;
  };

  services.dwm-status = {
    enable = true;
    order = [
      "audio"
      #"backlight"
      "battery"
      "cpu_load"
      "network"
      "time"
    ];
    extraConfig = ''
      separator = " | "

      [audio]
      icons = [ "奄", "奔", "墳" ]
      mute = "ﱝ"
      template = "{ICO} {VOL}%"

      [battery]
      charging = ""
      discharging = ""
      no_battery = " No battery"
      icons = ["", "", "", "", "", "", "", "", "", "", ""]

      [cpu_load]
      template = " {CL1}"
      update_interval = 15

      [network]
      no_value = "睊 Not connected"
      template = "直 {IPv4}"
    '';
  };

  services.xserver = {
    enable = true;
    windowManager.dwm.enable = true;
    displayManager.lightdm.enable = true;
    desktopManager = {
      wallpaper = {
        mode = "center";
      };
    };

    videoDrivers = [ "modesetting" ];

    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      enable = true;
      touchpad.tapping = true;
      touchpad.naturalScrolling = true;
    };
    # Configure keymap in X11
    layout = "dk";

    xautolock = {
      enable = true;
      time = 10;
      locker = slock-command;
      extraOptions = [
        #"-lockaftersleep"
        "-detectsleep"
      ];
    };
  };

  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";
    #experimentalBackends = true;
  };

  services.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        change-bavkground = "systemctl --user restart bg-setter";
      };
    };
  };

  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      alexander = {
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "vboxusers"
          "docker"
          "audio"
        ];
      };
    };
    extraGroups.vboxusers.members = [ "alexander" ];
    extraGroups.docker.members = [ "alexander" ];
  };

  environment.variables = {
    # NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    # NIX_LD = pkgs.runCommand "ld.so" { } ''
    #   ln -s "$(cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker')" $out
    # '';
    NIX_LD = "${pkgs.runCommand "ld.so" {} ''
      ln -s "$(cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker')" $out
    ''}";
  };

  environment.systemPackages = with pkgs; [
    (kodi.withPackages (p: with p; [ joystick ]))
    inputs.agenix.defaultPackage.${system}
    inputs.deploy-rs.defaultPackage.${system}
    inputs.devenv.defaultPackage.${system}
    cachix
    postgresql
    ungoogled-chromium
    kubectl
    mkchromecast
    lazygit
    nodejs
    nodePackages.npm
    beekeeper-studio
    postman
    brave
    gimp
    imagemagick
    slack
    docker-compose
    ranger
    #ungoogled-chromium
    dunst
    xmrig
    bitwarden
    #torbrowser
    unstable.mullvad-vpn
    arandr
    bashmount
    gparted
    pcmanfm
    pavucontrol
    tdesktop
    xss-lock
    xorg.xev
    xclip
    brightnessctl # Brightness from terminal
    dmenu
    st
    spotify
    libreoffice
    tmate
    # session-desktop-appimage
    unstable.session-desktop
    discord
    zip
    unzip
    flameshot
    firefox
    zathura
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.slock = {
    enable = true;
  };

  programs.nm-applet = {
    enable = true;
  };

  programs.xss-lock = {
    enable = true;
    #lockerCommand = "${pkgs.xautolock}/bin/xautolock -locknow";
    lockerCommand = slock-command;
  };

  programs.git = {
    config.user.email = "alexander.nortung@oakdigital.dk";
  };

  services.redshift = {
    enable = true;
    temperature.night = 2900;
  };

  services.mullvad-vpn.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  system.stateVersion = "21.11";
}
