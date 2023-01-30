{ pkgs, ... }:

{
  imports = [
    ../../modules/sound.nix
  ];

  users.users.player = {
    isNormalUser = true;
    extraGroups = [
      "video"
      "audio"
    ];
  };
  services.xserver = {
    enable = true;
    displayManager.autoLogin.user = "player";
    # desktopManager.retroarch = {
    #   enable = true;
    #   package = pkgs.retroarchFull;
    # };

    # desktopManager.session = [{
    #   name = "GameHub";
    #   start = ''
    #     ${pkgs.gamehub}/bin/gamehub &
    #     waitPID=$!
    #   '';
    # }];
    # desktopManager.session = [{
    #   name = "superTuxKart";
    #   start = ''
    #     ${pkgs.superTuxKart}/bin/supertuxkart &
    #     waitPID=$!
    #   '';
    # }];

    desktopManager.gnome.enable = true;

  };

  environment.systemPackages = with pkgs; [
    superTuxKart
  ];
}
