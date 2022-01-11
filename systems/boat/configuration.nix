# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, lib, ... }:

let
  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
    "discord"
    "spotify" "spotify-unwrapped"
    "minecraft" "minecraft-launcher"
    "vscode-extension-ms-vsliveshare-vsliveshare"
    "steam" "steam-original"
    "steam-runtime"
  ];
  slock-command = "/run/wrappers/bin/slock";
in
let
  nixos-version-fetched = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/tags/nixos-unstable";
    rev = "386234e2a61e1e8acf94dfa3a3d3ca19a6776efb";
  };
  nixos-version = import "${nixos-version-fetched}" { 
    inherit (config.nixpkgs) config overlays localSystem crossSystem;
  };
  unstable = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    rev = "aada45dcb08c27602c3d78bf13b6e718471c9159";
  }) { 
    config = {
      allowUnfreePredicate = allowUnfreePredicate;
    };
  };
  hardware-rep = builtins.fetchGit {
    url = "https://github.com/NixOS/nixos-hardware.git";
    rev = "3aabf78bfcae62f5f99474f2ebbbe418f1c6e54f";
  };
  local-pkgs = import "/home/alexander/source/nixpkgs" {
    config.permittedInsecurePackages = [
      "adoptopenjdk-jre-hotspot-bin-14.0.2"
      "adoptopenjdk-jre-hotspot-bin-13.0.2"
    ];
  };
in
let
  #pkgs = nixos-version;
in
{
  imports = [
    "${hardware-rep}/dell/latitude/3480"
    ../../common/nvim.nix
    ../../common/programming-pkgs.nix
    ../../common/comfort-packages.nix
    ../../common/sound.nix
    ../../common/console.nix
    ../../common/personal-vpn.nix
    ../../common/vscodium.nix
    ../../common/latex.nix
    ../../common/nord-lightdm.nix
    ../../common/nord-gtk.nix
    ../../common/basic-desktop.nix
    ../../common/zsh.nix
  ];

  swapDevices = [
    {
      label = "swap";
    }
  ];

  nixpkgs.pkgs = nixos-version;

  nix.nixPath = [
    "nixpkgs=${nixos-version-fetched}"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

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
      # Boot animation
    };
    plymouth = {
      enable = true;
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
    hostName = "boat";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    networkmanager = {
      enable = true;
    };
    wireguard = {
      enable = true;
    };
    firewall = {
      checkReversePath = lib.mkForce "loose";
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
      ];
    };
    wg-quick.interfaces.wg0 = {
      address = [ "10.100.0.3" ];
      privateKeyFile = "/etc/nixos/secret/wg-keys/boat-private";
    };
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

  services.autorandr = {
    enable = true;
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
    displayManager.lightdm = {
      enable = true;
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
    qutebrowser
    #unstable.steam
    #gimp
    docker-compose
    ranger
    unstable.ungoogled-chromium
    #godot
    dunst
    unstable.xmrig
    conky
    bitwarden
    unstable.torbrowser
    unstable.mullvad-vpn
    arandr
    unstable.minecraft
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
    bvi # hex editor with vim bindings
    unstable.session-desktop-appimage
    unstable.discord
    zip unzip
    flameshot
    joplin-desktop
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

  programs.steam.enable = true;

  programs.slock = {
    enable = true;
  };

  programs.nm-applet = {
    enable = true;
  };

  programs.xss-lock = {
    enable = true;
    #lockerCommand = "${pkgs.slock}/bin/slock";
    lockerCommand = slock-command;
  };

  programs.dconf = {
    enable = true;
  };

  services.redshift = {
    enable = true;
    temperature.night = 2900;
  };

  services.mullvad-vpn.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker = {
    enable = true;
  };

  #services.minecraft-server = {
  #  enable = true;
  #  package = local-pkgs.papermc-1_10_x;
  #  eula = true;
  #};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

