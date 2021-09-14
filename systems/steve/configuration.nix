# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <unstable>{};
  pkgs-ff89 = import (builtins.fetchGit {
    #name = "pkgs-ff89";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "860b56be91fb874d48e23a950815969a7b832fbc";
  }) {};
in
{
  imports = [
      ../../common/nvim.nix
      ../../common/console.nix
      ../../common/sound.nix
      ../../common/comfort-packages.nix
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

          #Anybar
          #(super.fetchpatch {
          #  url = "https://github.com/mihirlad55/dwm-anybar/releases/download/v1.1.1/dwm-anybar-20200905-bb2e722.diff";
          #  sha256 = "1rv8395dv79bq7pjgny4m317y68cvlhk7fgfq19nwg17bgpgczas";
          #})

          # alwaysfullscreen - focus does not drift off when in fullscreen
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/alwaysfullscreen/dwm-alwaysfullscreen-6.1.diff";
            sha256 = "1nfdjjb44c8j96v85zr6f38y7yndz5rh2x17wswyfc9178kvng0d";
          })
          #(super.fetchpatch {
          #  url = "https://dwm.suckless.org/patches/anybar/dwm-anybar-20200810-bb2e722.diff";
          #  sha256 = "0n2pqy0lwvkkiz9lc9q4qkbyb1rx8a8mhj51g541n5fri5pv1xb0";
          #})
        ];
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
      });
      dmenu = super.dmenu.overrideAttrs (oldAttrs : rec {
        #postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
        patches = [
          (super.fetchpatch {
            url = "https://tools.suckless.org/dmenu/patches/case-insensitive/dmenu-caseinsensitive-5.0.diff";
            sha256 = "0ib7m09rpswqlakr55aqg66a1fa0lf2aivm0rrz5541ih8ggfzsc";
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
            sha256 = "0i0fav13sxnsydpllny26139gnzai66222502cplh18iy5fir3j1";
          })
          # Alpha
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff";
            sha256 = "11dj1z4llqbbki5cz1k1crr7ypnfqsfp7hsyr9wdx06y4d7lnnww";
          })

          #(fetchpatch {
          #  url = "https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff";
          #  sha256 = "9c5b4b4f23de80de78ca5ec3739dc6ce5e7f72666186cf4a9c6b614ac90fb285";
          #})
          # Ligatures
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-alpha-scrollback-20200430-0.8.3.diff";
            sha256 = "1628l6x6a2nginyixvav13f2cbpg9yhj506kbjkwrn4zhhfnicx7";
          })
        ];

      });
    })
  ];
  services.xserver.windowManager.dwm.enable = true;
  #services.xserver.windowManager.awesome.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
    
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
  };

  environment.variables = {
    "ZOOM_HOME" = "/home/zoom/zoomus";
  };

  environment.systemPackages = with pkgs; [
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
    (pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        bbenoist.Nix
        james-yu.latex-workshop
        ms-vsliveshare.vsliveshare
	#ionide.ionide-fsharp
        #vsliveshare
      ]; #
      #++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #  {
      #    name = "ionide-fsharp";
      #    publisher = "ionide";
      #    version = "5.5.5";
      #    sha256 = "";
      #  }
      #];
    })
    glances
    texlive.combined.scheme-full
    wget
    pkgs-ff89.firefox
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
    minecraft
    discord
    obs-studio
    gimp
    spotify
    wine
    winetricks
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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 4713 6000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  nixpkgs.config.allowUnfree = true;

  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "enp5s0";
}
