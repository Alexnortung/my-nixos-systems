# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

let
  system = "x86_64-linux";
  unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  # unstable-overlay = import ../../overlays/unstable.nix inputs system;
in
{
  imports = [
    ./hardware-configuration.nix
    # ../../modules/nvim.nix
    ../../modules/programming-pkgs.nix
    ../../modules/comfort-packages.nix
    ../../modules/sound.nix
    ../../modules/console.nix
    #../../modules/personal-vpn.nix
    # ../../modules/latex.nix
    # ../../modules/nord-lightdm.nix
    ../../modules/nord-gtk.nix
    ../../modules/basic-desktop.nix
    ../../modules/zsh.nix
    # ../../modules/vscodium.nix
    ../../modules/location-denmark.nix
    # ../../profiles/registries.nix
    ../../profiles/nix-ld.nix
  ];

  # nixpkgs.config = {
  #   chromium = {
  #     enableWideVine = true;
  #   };
  # };

  nix = {
    package = unstable.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [
        "root"
        "alexander"
      ];
    };
  };

  services.flatpak.enable = true;

  services.s3fs-fuse = {
    enable = true;
    mounts = {
      backup-1 = {
        mountPoint = "/mnt/backup";
        bucket = "backup-1";
        options = [
          "passwd_file=/home/alexander/.config/s3fs/backup"
          "use_path_request_style"
          "allow_other"
          "url=https://ams1.vultrobjects.com"
        ];
      };
    };
  };

  boot = {
    # kernelParams = [ "nvidia-drm.modeset=1" ];
    extraModulePackages = with config.boot.kernelPackages; [
      # nvidia_x11
    ];
    kernelModules = [
      "msr"
    ];
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  hardware.opengl.extraPackages = with pkgs; [
    # Amd stuff
    rocm-opencl-icd

    glfw
  ];

  # hardware.nvidia = {
  #   # modesetting.enable = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  #   nvidiaPersistenced = true;
  #   # prime = {
  #   #   sync.enable = true;
  #   #   nvidiaBusId = "PCI:1:0:0";
  #   #   # intelBusId = "PCI:0:1:0";
  #   # };
  # };

  networking = {
    # dhcpcd.enable = false;
    enableIPv6 = false;
    dhcpcd = {
      # enable = true;
      extraConfig = '''';
    };
    hostName = "steve";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  powerManagement = {
    cpufreq.max = 3800000;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # windowManager.dwm.enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;
  };

  programs.dconf = {
    enable = true;
  };

  programs.adb.enable = true;

  # services.bg-setter = {
  #   enable = true;
  #   wallpaper = lib.lists.elemAt (import ../../config/misc/nord-wallpapers.nix { }) 0;
  # };
  #
  # services.autorandr = {
  #   enable = true;
  #   defaultTarget = "horizontal";
  #   hooks = {
  #     postswitch = {
  #       "change-background" = "systemctl --user restart bg-setter";
  #     };
  #   };
  # };

  fonts.packages = with pkgs; [
    hasklig
    terminus-nerdfont
  ];

  # services.dwm-status = {
  #   enable = true;
  #   order = [
  #     "audio"
  #     "cpu_load"
  #     "time"
  #   ];
  #   extraConfig = ''
  #     separator = " | "
  #
  #     [audio]
  #     icons = [ "奄", "奔", "墳" ]
  #     mute = "ﱝ"
  #     template = "{ICO} {VOL}%"
  #
  #     [cpu_load]
  #     template = " {CL1}"
  #     update_interval = 15
  #   '';
  # };

  # Redshift
  services.redshift = {
    enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "dk";

  users.users = {
    alexander = {
      isNormalUser = true;
      home = "/home/alexander";
      extraGroups = [ "wheel" "video" "audio" "adbusers" "docker" "wireshark" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.zsh;
    };
    morgan = {
      isNormalUser = true;
      home = "/home/morgan";
      extraGroups = [ "audio" "video" ];
      shell = pkgs.zsh;
    };
  };
  users.extraGroups.docker.members = [ "alexander" ];

  # programs.ssh.forwardX11 = true;
  #programs.ssh.startAgent = true;

  # List packages installed in system profile. To search, run:
  programs.steam.enable = true;
  programs.steam.gamescopeSession = {
    enable = true;
  };

  programs.gamemode.enable = true;

  programs.kdeconnect = {
    enable = true;
  };

  services.mullvad-vpn.enable = true;

  environment.sessionVariables = {
    MOZ_X11_EGL = "1";
    # "CUDA_PATH" = "${pkgs.cudatoolkit}";
  };

  programs.corectrl.enable = true;

  programs.wireshark.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  environment.systemPackages = with pkgs; [
    android-tools
    gnome.gnome-software
    docker-compose
    gnomeExtensions.gnome-bedtime
    gnomeExtensions.appindicator
    webcord
    inputs.agenix.packages.${system}.agenix
    inputs.devenv.packages.${system}.devenv
    zulu
    prismlauncher
    glfw
    bind
    metasploit
    qbittorrent
    wineWowPackages.stable
    winetricks
    inputs.deploy-rs.defaultPackage.x86_64-linux
    superTuxKart
    protonup
    autorandr
    libreoffice
    mullvad-vpn
    unstable.session-desktop
    krita
    # cudatoolkit
    # (blender.override {
    #   # cudaSupport = true;
    # })
    python39Packages.pygments
    zathura
    xorg.xhost
    # xpra
    socat
    bashmount
    # pinta
    appimage-run
    flameshot
    xclip
    # dotnet-sdk_5
    steam-run
    # godot
    # texlive.combined.scheme-full
    wget
    firefox
    ungoogled-chromium
    bitwarden
    xmrig
    # st
    # dwm
    neofetch
    dmenu
    dwm-status
    tdesktop # telegram
    redshift
    lsof
    pavucontrol
    usbutils
    libv4l
    # xorg.xrandr
    # arandr
    # linuxPackages.nvidia_x11
    #xorg.libpciaccess
    patchelf
    libGL
    libGLU
    glxinfo
    # minecraft
    discord
    obs-studio
    gimp
    spotify
    lutris
    vulkan-headers
    xorg.xev
    gcc
    playerctl
    oh-my-zsh
    libpulseaudio
  ];

  virtualisation.docker = {
    enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
