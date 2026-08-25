{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  # system = "x86_64-linux";
  system = pkgs.stdenv.hostPlatform.system;
  unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
in
{
  imports = [
    ./hardware-configuration.nix
    ../../config/stylix.nix
    ../../modules/programming-pkgs.nix
    ../../modules/comfort-packages.nix
    ../../modules/console.nix
    ../../modules/zsh.nix
    ../../modules/location-denmark.nix
    ../../profiles/allow-multicast.nix
    ../../profiles/registries.nix
    ../../modules/ssh-config.nix
    ../../modules/battery-notifier.nix
  ];

  time.timeZone = "Europe/Copenhagen";

  boot = {
    # Defaults after installing
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # kernelParams = [
    #   # "xe.force_probe=7d51"
    #   # "i915.force_probe=!7d51"
    #   "xe.force_probe=!7d51"
    #   "i915.force_probe=7d51"
    # ];
    #
    # initrd.kernelModules = [
    #   "i915"
    #   #"xe"
    # ];
  };

  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

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

  networking = {
    hostName = "paper";
    networkmanager.enable = true;
    useDHCP = false;
    enableIPv6 = true;
    interfaces.eno1.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.mullvad-vpn.enable = true;

  services.fwupd = {
    enable = true;
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns4 = true;
  };
  services.batteryNotifier = {
    enable = true;
    notifyCapacity = 15;
    hibernateCapacity = 5;
  };
  services.greetd = {
    enable = true;
  };
  programs.regreet.enable = true;

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
  };

  services.dbus.packages = [
    pkgs.gnome-keyring
    pkgs.gcr
  ];

  programs.nix-ld.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  services.libinput = {
    enable = true;
    touchpad.tapping = true;
    touchpad.naturalScrolling = true;
  };

  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [
        "root"
        "alex"
      ];
    };
  };

  hardware.bluetooth = {
    enable = true;
  };
  services.blueman.enable = true;

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  programs.nm-applet.enable = true;
  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    nerd-fonts.symbols-only
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # set the flake package
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # # make sure to also set the portal package, so that they are in sync
    # portalPackage =
    #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  programs.git = {
    config.user.email = "an@dokumenter.dk";
  };

  programs.firefox.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  # environment.etc."xdg/alacritty/alacritty.toml".source = ../config/alacritty.toml;

  users = {
    users = {
      alex = {
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "vboxusers"
          "docker"
          "kvm"
          "audio"
          "networkmanager"
        ];
      };
    };
    extraGroups.vboxusers.members = [ "alex" ];
    extraGroups.docker.members = [ "alex" ];

  };

  security.polkit.enable = true;

  services.gnome.gcr-ssh-agent.enable = true;
  services.gnome.gnome-keyring = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    seahorse
    solaar
    nodejs
    docker-compose
    bashmount
    pcmanfm
    xev
    wl-clipboard
    brightnessctl # Brightness from terminal
    libreoffice
    zip
    unzip
    flameshot
  ];

  system.stateVersion = "25.05";
}
