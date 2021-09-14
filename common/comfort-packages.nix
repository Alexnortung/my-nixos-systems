{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    bash
    lm_sensors
    gnumake
    zip unzip
    croc
    nmap
    vim
    git
    pciutils
    htop
  ];
}
