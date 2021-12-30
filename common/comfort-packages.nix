{ pkgs, config, ... }:

{
  imports = [
    ./git-config.nix
  ];
  programs.htop = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    git
    bash
    lm_sensors
    gnumake
    zip unzip
    croc
    nmap
    vim
    pciutils
    neofetch
  ];
}
