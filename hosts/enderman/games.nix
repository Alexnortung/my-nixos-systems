{ pkgs, config, ... }:

let
  autostart = ''
    ${config.programs.steam.package}/bin/steam -bigpicture &
  '';

  user = "player";
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

    displayManager.defaultSession = "none+openbox";
    windowManager.openbox.enable = true;
  };

  # systemd.user.services.steam = {
  #   description = "Steam systemd service";
  #   wantedBy = [ "graphical-session.target" "multi-user.target" ];
  #   partOf = [ "graphical-session.target" ];
  #
  #   serviceConfig = {
  #     ExecStart = "${config.programs.steam.package}/bin/steam -bigpicture";
  #     # Restart = "on-failure";
  #   };
  # };

  networking = {
    networkmanager = {
      enable = true;
    };
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    superTuxKart
  ];

  environment.etc."xdg/openbox/autostart".source = pkgs.writeScript "autostart" autostart;
}
