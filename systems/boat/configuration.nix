# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  unstable = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    rev = "b01baaebac95d24a51be0ededd92e3a965569605";
  }) { 
    config = config.nixpkgs.config;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ../../common/nvim.nix
      ../../common/programming-pkgs.nix
      ../../common/comfort-packages.nix
      ../../common/sound.nix
      ../../common/console.nix
    ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "discord"
      "spotify" "spotify-unwrapped"
    ];
  };

  nixpkgs.overlays = [
    (self: super: {
      st = super.st.overrideAttrs (oldAttrs : rec {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
        configFile = super.writeText "config.h" (builtins.readFile ./config/st-config.h);
        postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
        patches = [
          # Scrollback
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.4.diff";
            sha256 = "0valvkbsf2qbai8551id6jc0szn61303f3l6r8wfjmjnn4054r3c";
          })
          # Alpha
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff";
            sha256 = "158k93bbgrmcajfxvkrzfl65lmqgj6rk6kn8yl6nwk183hhf5qd4";
          })
          # Ligatures
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-alpha-scrollback-20200430-0.8.3.diff";
            sha256 = "1y6fl31fz1ks43v80ccisz781zzf6fgaijdhcbvkxy2d009xla27";
          })
          # Desktop entry - gives an icon
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/desktopentry/st-desktopentry-0.8.4.diff";
            sha256 = "0v0hymybm2yplrvdjqysvcyhl36a5llih8ya9xjim1fpl609hg8y";
          })
          # More icon
          (super.fetchpatch {
            url = "http://st.suckless.org/patches/netwmicon/st-netwmicon-0.8.4.diff";
            sha256 = "0gnk4fibqyby6b0fdx86zfwdiwjai86hh8sk9y02z610iimjaj1n";
          })

        ];
      });
      dwm = super.dwm.overrideAttrs (oldAttrs : rec {
        configFile = super.writeText "config.h" (builtins.readFile ./config/dwm-config.h);
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
        patches = [
          # alwaysfullscreen - focus does not drift off when in fullscreen
          #(super.fetchpatch {
          #  url = "https://dwm.suckless.org/patches/alwaysfullscreen/dwm-alwaysfullscreen-6.1.diff";
          #  sha256 = "1037m24c1hd6c77p84szc5qqaw4kldwwfzggyn6ac5rv8l47j057";
          #})
          # Systray
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/systray/dwm-systray-6.2.diff";
            sha256 = "1p1hzkm5fa9b51v19w4fqmrphk0nr0wnkih5vsji8r38nmxd4ydp";
          })
        ];
      });
      dmenu = super.dmenu.overrideAttrs (oldAttrs : rec {
        #postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
        patches = [
          (super.fetchpatch {
            url = "https://tools.suckless.org/dmenu/patches/case-insensitive/dmenu-caseinsensitive-5.0.diff";
            sha256 = "0bb0iwv8d53dibzqc307y3z852whwxjzjrxkbs07cs5y3c2l98ay";
          })
        ];
      });
    })
  ];

  fonts.fonts = with pkgs; [
    hasklig
    terminus-nerdfont
  ];


  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      version = 2;
      devices = [ "nodev" ];
      enable = true;
      efiSupport = true;
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
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
      #locker = "${pkgs.slock}/bin/slock";
      extraOptions = [
        #"-lockaftersleep"
        "-detectsleep"
      ];
    };
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "simple";
    };
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
          "audio"
        ];
      };
    };
    extraGroups.vboxusers.members = [ "alexander" ];
  };


  environment.systemPackages = with pkgs; [
    bashmount
    gparted
    pcmanfm
    pavucontrol
    unstable.tdesktop
    python39Packages.pygments
    xss-lock
    xorg.xev
    xclip
    i3lock
    #i3lock-blur
    brightnessctl # Brightness from terminal
    dmenu
    st
    spotify
    libreoffice
    tmate
    bvi # hex editor with vim bindings
    unstable.session-desktop-appimage
    texlive.combined.scheme-full
    unstable.discord
    zip unzip
    flameshot
    joplin-desktop
    vim
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
    lockerCommand = "${pkgs.xautolock}/bin/xautolock -locknow";
  };

  services.redshift = {
    enable = true;
    temperature.night = 2900;
  };

  virtualisation.virtualbox.host.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

