{ inputs, config, lib, pkgs, ... }:

let
  ssh-keys = import ../../config/ssh;
  authorizedKeyFiles = with ssh-keys; [
    boat
    steve
    spider
  ];
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./secrets
      ./wireguard.nix
      ./nginx.nix
      ./mail-server.nix
      ./vaultwarden.nix
      ../../modules/console.nix
      ../../modules/comfort-packages.nix
      ../../profiles/registries.nix
    ];

  networking.hostName = "end"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # networking.nat.internalInterfaces = [ "wg0" ];

  environment.systemPackages = with pkgs; [
    inputs.agenix.defaultPackage.x86_64-linux
    nmap
    git
    zip unzip
    wireguard-tools
    file
    curl
    #vim
    croc
    lm_sensors
    htop
    borgbackup
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    openFirewall = true;
    permitRootLogin = "without-password";
    passwordAuthentication = false;
    banner = ''
          .-~~~-.
  .- ~ ~-(       )_ _
 /                     ~ -.
|         END               \
 \                         .'
   ~- . _____________ . -~
    '';
  };
  
  users = {
    users = {
      root.openssh.authorizedKeys.keyFiles = authorizedKeyFiles;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    21
    22
    50001
  ];
  networking.firewall.allowedUDPPorts = [
    51820 # wireguard
  ];

  system.stateVersion = "22.05";
}

