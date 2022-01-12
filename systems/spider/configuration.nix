# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, ... }:

let
  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
    "discord"
    "spotify" "spotify-unwrapped"
    "minecraft" "minecraft-launcher"
    "vscode-extension-ms-vsliveshare-vsliveshare"
    "slack"
  ];
  slock-command = "/run/wrappers/bin/slock";
in
let
  nixos-version-fetched = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixos-21.11";
    rev = "386234e2a61e1e8acf94dfa3a3d3ca19a6776efb";
  };
  nixos-version = import "${nixos-version-fetched}" { 
    inherit (config.nixpkgs) config overlays localSystem crossSystem;
  };
  unstable = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    rev = "931ab058daa7e4cd539533963f95e2bb0dbd41e6";
  }) { 
    config = {
      allowUnfreePredicate = allowUnfreePredicate;
    };
  };
  hardware-rep = builtins.fetchGit {
    url = "https://github.com/NixOS/nixos-hardware.git";
    rev = "3aabf78bfcae62f5f99474f2ebbbe418f1c6e54f";
  };
in
let
  pkgs = nixos-version;
in
{
  imports = [
    "${hardware-rep}/lenovo/thinkpad/x13"
    ../../common/nvim.nix
    ../../common/programming-pkgs.nix
    ../../common/comfort-packages.nix
    ../../common/sound.nix
    ../../common/console.nix
    #../../common/personal-vpn.nix
    ../../common/vscodium.nix
    ../../common/latex.nix
    ../../common/nord-lightdm.nix
    ../../common/nord-gtk.nix
    ../../common/basic-desktop.nix
    ../../common/zsh.nix
  ];

  hardware.bluetooth = {
    enable = true;
  };

  swapDevices = [
    {
      label = "swap";
    }
  ];

  nixpkgs.pkgs = nixos-version;

  #nix.nixPath = [
  #  "nixpkgs=${nixos-version-fetched}"
  #  "nixos-config=/etc/nixos/configuration.nix"
  #  "/nix/var/nix/profiles/per-user/root/channels"
  #];

  nixpkgs.config = {
    allowUnfreePredicate = allowUnfreePredicate;
    packageOverrides = pkgs: {
      mullvad-vpn = unstable.mullvad-vpn;
    };
  };

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
      systemd-boot = {
        enable = true;
      };
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
      checkReversePath = lib.mkForce "loose";
    };
    #wg-quick.interfaces.wg0 = {
    #  address = [ "10.100.0.3" ];
    #  privateKeyFile = "/etc/nixos/secret/wg-keys/boat-private";
    #};
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.batteryNotifier = {
    enable = true;
    notifyCapacity = 15;
    hibernateCapacity = 5;
  };

  services.bg-setter = {
    enable = true;
    wallpaper = lib.lists.elemAt (import ../../common/misc/nord-wallpapers.nix {}) 0;
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
    #backend = "glx";
    #experimentalBackends = true;
  };

  services.autorandr = {
    enable = true;
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

  environment.systemPackages = with pkgs; [
    gimp
    imagemagick
    unstable.dbeaver
    slack-term
    slack
    docker-compose
    ranger
    unstable.ungoogled-chromium
    dunst
    unstable.xmrig
    conky
    bitwarden
    #unstable.torbrowser
    unstable.mullvad-vpn
    arandr
    bashmount
    gparted
    pcmanfm
    pavucontrol
    unstable.tdesktop
    python39Packages.pygments
    xss-lock
    xorg.xev
    xclip
    brightnessctl # Brightness from terminal
    dmenu
    st
    spotify
    libreoffice
    tmate
    unstable.session-desktop-appimage
    unstable.discord
    zip unzip
    flameshot
    vim
    unstable.firefox
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

  services.redshift = {
    enable = true;
    temperature.night = 2900;
  };

  services.mullvad-vpn.enable = true;

  virtualisation.docker = {
    enable = true;
  };
}

