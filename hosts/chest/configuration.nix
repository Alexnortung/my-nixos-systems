{ inputs, pkgs, ... }:
let
  hostname = "chest";
  timeZone = "Europe/Copenhagen";
  user = "nixos";
  ssh-keys = import ../../config/ssh;
  authorizedKeyFiles = with ssh-keys; [
    boat
    steve
    spider
  ];
in
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [
        "root"
        user
      ];
    };
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = hostname;
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];

  services.openssh.enable = true;

  time.timeZone = timeZone;

  users = {
    mutableUsers = false;
    users = {
      "${user}" = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keyFiles = authorizedKeyFiles;
      };

      root.openssh.authorizedKeys.keyFiles = authorizedKeyFiles;
    };
  };

  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = [ user ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  system.stateVersion = "23.11";
}
