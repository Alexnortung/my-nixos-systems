{ inputs
, config
, lib
, pkgs
, ...
}:
let
  ssh-keys = import ../../config/ssh;
  system = "x86_64-linux";
  authorizedKeyFiles = with ssh-keys; [
    boat
    steve
    spider
  ];
in
{
  imports = [
    # Include the results of the hardware scan.
    # ../../config/backup-bucket.nix
    ./hardware-configuration.nix
    ./secrets
    ./db.nix
    # ./nextcloud.nix
    ./wireguard.nix
    ./nginx.nix
    # ./reverse-proxy.nix
    ./mail-server.nix
    ./vaultwarden.nix
    ./monero.nix
    ../../modules/console.nix
    ../../modules/comfort-packages.nix
    # ../../profiles/registries.nix
    ./factorio.nix
  ];

  networking.hostName = "end"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   dockerSocket.enable = true;
  # };

  virtualisation.docker = {
    enable = true;
  };

  # networking.nat.internalInterfaces = [ "wg0" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    neovim
    inputs.agenix.packages.${system}.agenix
    nmap
    git
    zip
    unzip
    wireguard-tools
    file
    curl
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
    settings = {
      PermitRootLogin = "without-password";
      PasswordAuthentication = false;
    };
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
