# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  config,
  lib,
  inputs,
  ...
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
    ../../config/stylix.nix
    ../../modules/automount.nix
    ../../modules/personal-vpn.nix
    ../../modules/programming-pkgs.nix
    ../../modules/comfort-packages.nix
    # ../../modules/sound.nix
    ../../modules/console.nix
    # ../../modules/vscodium.nix
    # ../../modules/latex.nix
    # ../../modules/nord-lightdm.nix
    # ../../modules/nord-gtk.nix
    ../../modules/basic-desktop.nix
    ../../modules/zsh.nix
    ../../modules/location-denmark.nix
    ../../profiles/allow-multicast.nix
    ../../profiles/registries.nix
    ../../modules/ssh-config.nix
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

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # swapDevices = [
  #   {
  #     label = "swap";
  #   }
  # ];

  fonts.packages = with pkgs; [
    fira-code
    hasklig
    nerdfonts
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
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
    enableIPv6 = true;
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
        8888 # Jupyter
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
  services.printing.drivers = with pkgs; [
    gutenprint
    foomatic-db-ppds
  ];
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns4 = true;
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
    enable = false;
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
      icons = [ "󰕿", "󰖀", "󰕾" ]
      mute = "󰖁"
      template = "{ICO} {VOL}%"

      [battery]
      charging = ""
      discharging = ""
      no_battery = " No battery"
      icons = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

      [cpu_load]
      template = " {CL1}"
      update_interval = 15

      [network]
      no_value = " Not connected"
      template = " {IPv4}"
    '';
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme";
  };

  services.xserver = {
    enable = true;

    # windowManager.dwm.enable = true;
    # displayManager.lightdm.enable = true;
    # desktopManager = { wallpaper = { mode = "center"; }; };

    # videoDrivers = [ "modesetting" ];

    # Enable touchpad support (enabled default in most desktopManager).
    # Configure keymap in X11
    xkb.layout = "dk";

    # xautolock = {
    #   enable = true;
    #   time = 10;
    #   locker = slock-command;
    #   extraOptions = [
    #     #"-lockaftersleep"
    #     "-detectsleep"
    #   ];
    # };
  };

  programs.hyprland = {
    enable = true;
  };

  programs.hyprlock = {
    enable = true;
  };

  services.libinput = {
    enable = true;
    touchpad.tapping = true;
    touchpad.naturalScrolling = true;
  };

  services.picom = {
    enable = false;
    vSync = true;
    backend = "glx";
    #experimentalBackends = true;
  };

  services.autorandr = {
    enable = false;
    hooks = {
      postswitch = {
        change-background = "systemctl --user restart bg-setter";
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
    # NIX_LD = "${pkgs.runCommand "ld.so" {} ''
    #   ln -s "$(cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker')" $out
    # ''}";
  };

  environment.systemPackages = with pkgs; [
    where-is-my-sddm-theme
    kitty
    gftp
    solaar
    kondo
    inputs.agenix.packages.${system}.agenix
    inputs.deploy-rs.defaultPackage.${system}
    inputs.devenv.packages.${system}.devenv
    cachix
    postgresql_15
    ungoogled-chromium
    kubectl
    # mkchromecast
    nodejs
    nodePackages.npm
    beekeeper-studio
    # brave
    # gimp
    imagemagick
    slack
    docker-compose
    dunst
    xmrig
    bitwarden
    #torbrowser
    unstable.mullvad-vpn
    arandr
    bashmount
    # gparted
    pcmanfm
    pavucontrol
    xss-lock
    xorg.xev
    wl-clipboard
    brightnessctl # Brightness from terminal
    dmenu
    st
    spotify
    libreoffice
    tmate
    # unstable.session-desktop
    # discord
    zip
    unzip
    flameshot
    firefox-bin
    zathura
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # programs.slock = { enable = true; };

  programs.nm-applet = {
    enable = true;
  };

  # programs.xss-lock = {
  #   enable = true;
  #   #lockerCommand = "${pkgs.xautolock}/bin/xautolock -locknow";
  #   lockerCommand = slock-command;
  # };

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
