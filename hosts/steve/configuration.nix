# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

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
    ../../modules/nord-lightdm.nix
    ../../modules/nord-gtk.nix
    ../../modules/basic-desktop.nix
    ../../modules/zsh.nix
    # ../../modules/vscodium.nix
    ../../modules/location-denmark.nix
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  boot = {
    # kernelParams = [ "nvidia-drm.modeset=1" ];
    extraModulePackages = with config.boot.kernelPackages; [
      # nvidia_x11
    ];
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
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
    hostName = "steve";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.dwm.enable = true;
  };

  services.bg-setter = {
    enable = true;
    wallpaper = lib.lists.elemAt (import ../../config/misc/nord-wallpapers.nix { }) 0;
  };

  services.autorandr = {
    enable = true;
    defaultTarget = "horizontal";
    hooks = {
      postswitch = {
        "change-background" = "systemctl --user restart bg-setter";
      };
    };
  };

  fonts.fonts = with pkgs; [
    hasklig
    terminus-nerdfont
  ];

  services.dwm-status = {
    enable = true;
    order = [
      "audio"
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

      [cpu_load]
      template = " {CL1}"
      update_interval = 15

      [network]
      no_value = "睊 Not connected"
      template = "直 {IPv4}"
    '';
  };

  # Redshift
  services.redshift = {
    enable = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "dk";

  users.users = {
    alexander = {
      isNormalUser = true;
      home = "/home/alexander";
      extraGroups = [ "wheel" "video" "audio" "adbusers" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.zsh;
    };
    morgan = {
      isNormalUser = true;
      home = "/home/morgan";
      extraGroups = [ "audio" "video" ];
      shell = pkgs.zsh;
    };
  };

  # programs.ssh.forwardX11 = true;
  #programs.ssh.startAgent = true;

  # List packages installed in system profile. To search, run:
  programs.steam.enable = true;

  programs.kdeconnect = {
    enable = true;
  };

  nixpkgs.config = {
    # cudaSupport = true; # enable cuda for all packages that supprot it.
    packageOverrides = pkgs: {
      #steam = pkgs-steam.steam.override {
      #  extraPkgs = pkgs:  [
      #  ];
      #  extraLibraries = pkgs: [
      #    pkgs.pipewire
      #  ];
      #};
    };
  };

  services.mullvad-vpn.enable = true;

  environment.sessionVariables = {
    MOZ_X11_EGL = "1";
    # "CUDA_PATH" = "${pkgs.cudatoolkit}";
  };

  environment.systemPackages = with pkgs; [
    inputs.deploy-rs.defaultPackage.x86_64-linux
    lazygit
    superTuxKart
    protonup
    autorandr
    libreoffice
    mullvad-vpn
    session-desktop-appimage
    # cudatoolkit
    (blender.override {
      # cudaSupport = true;
    })
    python39Packages.pygments
    zathura
    xorg.xhost
    # xpra
    socat
    bashmount
    pinta
    appimage-run
    flameshot
    xclip
    # dotnet-sdk_5
    steam-run
    godot
    texlive.combined.scheme-full
    wget
    firefox
    ungoogled-chromium
    bitwarden
    xmrig
    st
    dwm
    neofetch
    dmenu
    dwm-status
    tdesktop # telegram
    redshift
    lsof
    pavucontrol
    usbutils
    libv4l
    xorg.xrandr
    arandr
    # linuxPackages.nvidia_x11
    #xorg.libpciaccess
    patchelf
    libGL
    libGLU
    glxinfo
    minecraft
    discord
    obs-studio
    gimp
    spotify
    # lutris
    vulkan-headers
    xorg.xev
    gcc
    pythonFull
    python3
    playerctl
    oh-my-zsh
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrender
    xorg.libX11
    xorg.libXi
    libpulseaudio
  ];

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
  system.stateVersion = "20.09"; # Did you read the comment?
}
