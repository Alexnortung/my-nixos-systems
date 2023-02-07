{ pkgs, ... }:

let
  autostart = ''
    #!${pkgs.bash}/bin/bash

    ${pkgs.kodi}/bin/kodi &
  '';

  user = "player";

  kodiWithPkgs = pkgs.kodi.withPackages (p: with p; [
    joystick
  ]);
in
{
  imports = [
    ../../modules/sound.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "video"
      "audio"
    ];
  };

  services.xserver = {
    enable = true;
    displayManager.autoLogin.user = user;
    libinput.enable = true;

    videoDrivers = [ "modesetting" ];

    # displayManager.defaultSession = "none+openbox";
    windowManager.openbox.enable = true;
    # desktopManager.kodi = {
    #   enable = true;
    #   package = kodiWithPkgs;
    # };
  };

  # systemd.services."display-manager".after = [
  #   "network-online.target"
  #   "systemd-resolved.service"
  # ];

  systemd.user.services.ums = {
    description = "UMS as systemd service";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.ums}/bin/ums";
      Restart = "on-failure";
    };
  };

  environment.systemPackages = with pkgs; [
    superTuxKart
  ];
}
