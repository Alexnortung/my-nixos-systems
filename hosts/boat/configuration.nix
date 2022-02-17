# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, config, lib, ... }:

let
  slock-command = "/run/wrappers/bin/slock";
  untable = inputs.unstable-boat;
  nixos-hardware = inputs.nixos-hardware-boat;
in
{
  imports = [
    ./hardware-configuration.nix
    "${nixos-hardware}/dell/latitude/3480"
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
    ../../common/misc/emojipick.nix
    ../../common/basic-desktop.nix
    ../../common/zsh.nix
    nur-alexnortung.modules.autorandr
  ];

  location = {
    latitude = 55.66283136357285;
    longitude = 12.534913904480344;
    provider = "manual";
  };

  disabledModules = [
    "services/misc/autorandr.nix"
  ];

  swapDevices = [
    {
      label = "swap";
    }
  ];

  nix = {
    package = unstable.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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

    binfmt.emulatedSystems = [ "aarch64-linux" ]; # aarch64 emulation
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
    hooks = {
      postswitch = {
        "change-background" = "systemctl --user restart bg-setter";
      };
    };
    profiles = {
      "morgan" = {
        fingerprint = {
          HDMI1 = "00ffffffffffff0034a401090000000033160103802c19782ac905a3574b9c25125054bfcf008bc081808140810081c0714f6140454f302a40c86084643018501300bbf91000001c9a29a0d05184223050983600bbf91000001c000000fd00384b1e510c000a202020202020000000fc004d4432303332390a2020202020000b";
          eDP1 = "00ffffffffffff0006af3d2100000000001a0104951f117802a2b591575894281c505400000001010101010101010101010101010101843a8034713828403064310035ad1000001ad02e8034713828403064310035ad1000001a000000fe00364d4e3737804231343048414e0000000000008102a8001100000a010a2020008e";
        };
        config = {
          eDP1 = {
            crtc = 0;
            gamma = "1.0:0.667:0.435";
            mode = "1920x1080";
            position = "0x900";
            primary = true;
            rate = "60.03";
          };
          HDMI1 = {
            enable = true;
            crtc = 1;
            gamma = "1.0:0.667:0.435";
            mode = "1600x900";
            position = "0x0";
            rate = "60.00";
          };
        };
      };
    };
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

    videoDrivers = [ "modesetting" ];
    useGlamor = true;

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
    vlc
    dotnet-sdk
    sage
    qutebrowser
    unstable.steam
    #gimp
    docker-compose
    ranger
    unstable.ungoogled-chromium
    #godot
    dunst
    # unstable.xmrig
    conky
    bitwarden
    # unstable.torbrowser
    # unstable.mullvad-vpn
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
