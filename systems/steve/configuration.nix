# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  #unstable = import <unstable>{
  #  config = config.nixpkgs.config;
  #};
  unstable = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    rev = "0a68ef410b40f49de76aecb5c8b5cc5111bac91d";
  }) {
    config = config.nixpkgs.config;
  };
in
{
  imports = [
      ../../common/nvim.nix
      ../../common/console.nix
      ../../common/sound.nix
      ../../common/comfort-packages.nix
      ../../common/vscodium.nix
    ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use boot animation
  boot.plymouth.enable = true;
  boot.plymouth.theme = "fade-in";

  boot.extraModulePackages = with config.boot.kernelPackages; [
    nvidia_x11
  ];

  networking.hostName = "steve";

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;


  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    #serverFlagsSection = ''
    #  Option "IndirectGLX" "on"
    #'';
    screenSection = ''
      Option "metamodes" "HDMI-0: nvidia-auto-select +1920+0 {ForceCompositionPipeline=On}, DVI-I-0: nvidia-auto-select +0+0 {ForceCompositionPipeline=On}"
    '';
  };
  #services.xserver.displayManager.startx.enable = true;
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        configFile = super.writeText "config.h" (builtins.readFile ./config/dwm-config.h);
        patches = [
          # alwaysfullscreen - focus does not drift off when in fullscreen
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/alwaysfullscreen/dwm-alwaysfullscreen-6.1.diff";
            sha256 = "sha256-pwB5CEU7F6aM9e99x3mjk3CFcWFfE3TPYabBwIioZ4A=";
          })
          # Systray
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/systray/dwm-systray-6.2.diff";
            sha256 = "1p1hzkm5fa9b51v19w4fqmrphk0nr0wnkih5vsji8r38nmxd4ydp";
          })
        ];
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
      });
      dmenu = super.dmenu.overrideAttrs (oldAttrs : rec {
        configFile = super.writeText "config.h" (builtins.readFile ./config/dmenu-config.h);
        postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
        patches = [
          (super.fetchpatch {
            url = "https://tools.suckless.org/dmenu/patches/case-insensitive/dmenu-caseinsensitive-5.0.diff";
            sha256 = "XqFEBRu+aHaAXrNn+WXnkIuC/vAHDIb/im2UhjaPYC0=";
          })
        ];
      });
      st = super.st.overrideAttrs (oldAttrs : rec {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
        configFile = super.writeText "config.h" (builtins.readFile ./config/st-config.h);
        postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
        patches = [
          # Scrollback
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.4.diff";
            sha256 = "bGRSALFWVuk4yoYON8AIxn4NmDQthlJQVAsLp9fcVG0=";
          })
          # Alpha
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff";
            sha256 = "pOHiIBwoTG4N9chOM7ORD1daDHU/z92dVKzmt9ZIE5U=";
          })
          # Ligatures
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-alpha-scrollback-20200430-0.8.3.diff";
            sha256 = "RyjaEwBN+D73YrDJqJ4z7v+AzteRMYD2IHqG78Kgzvg=";
          })
        ];
      });
    })
  ];

  fonts.fonts = with pkgs; [
    hasklig
    terminus-nerdfont
  ];

  services.xserver.windowManager.dwm.enable = true;

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

  services.xserver.displayManager = { 
    lightdm = {
      enable = true;
      #background = pkgs.nixos-artwork.wallpapers.simple-red.gnomeFilePath;
      background = /home/alexander/Pictures/backgrounds/pixel-art-astronaut-6jm0bumas1tmb7hc.jpg;
    };
  };
    
  # Redshift
  services.redshift = {
    enable = true;
  };
  
  systemd.services.setMonitors = {
    script = ''
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  # Configure keymap in X11
  services.xserver.layout = "dk";

  services.compton.enable = true;
  services.compton.vSync = true;

  programs.adb.enable = true;

  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "simple";
  };
  users.users = {
    alexander = {
      isNormalUser = true;
      home = "/home/alexander";
      extraGroups = [ "wheel" "audio" "adbusers" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.zsh;
    };
    morgan = {
      isNormalUser = true;
      home = "/home/morgan";
      extraGroups = [ "audio" ];
      shell = pkgs.zsh;
    };
    zoom = {
      isNormalUser = true;
      extraGroups = [ "audio" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        zoom-us
      ];
    };
  };
  users.groups = {
    zoom = {
      members = [ "zoom" ];
    };
  };

  programs.ssh.forwardX11 = true;
  programs.ssh.startAgent = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs.steam.enable = true;
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:  [
      ];
      extraLibraries = pkgs: [
        pkgs.pipewire
      ];
    };
  };

  environment.sessionVariables = {
    MOZ_X11_EGL = "1";
    "CUDA_PATH" = "${pkgs.cudatoolkit}";
  };

  environment.variables = {
    "ZOOM_HOME" = "/home/zoom/zoomus";
  };

  environment.systemPackages = with pkgs; [
    unstable.mullvad-vpn
    unstable.session-desktop-appimage
    cudatoolkit
    blender
    python39Packages.pygments
    futhark
    zathura
    xorg.xhost
    xpra
    socat
    bashmount
    pinta
    plantuml
    appimage-run
    flameshot
    xclip
    fsharp
    #dotnet-netcore
    dotnet-sdk_5
    steam-run
    godot
    glances
    texlive.combined.scheme-full
    wget
    unstable.firefox
    ungoogled-chromium
    bitwarden
    unstable.xmrig
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
    nvtop
    linuxPackages.nvidia_x11
    #xorg.libpciaccess
    patchelf
    libGL libGLU
    glxinfo
    unstable.minecraft
    unstable.discord
    obs-studio
    gimp
    spotify
    lutris
    vulkan-headers
    xorg.xev
    gcc
    rustc
    rustup
    rls
    pythonFull
    python3
    cargo
    rustfmt
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
    "discord"
    "spotify" "spotify-unwrapped"
    "minecraft" "minecraft-launcher"
    "steam" "steam-original" "steam-runtime"
    "vscode-extension-ms-vsliveshare-vsliveshare"
    "cudatoolkit"
    "zoom"
  ];

  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "enp5s0";
}
