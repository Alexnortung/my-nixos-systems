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

    desktopManager.kodi.enable = true;
  };

  environment.systemPackages = with pkgs; [
    superTuxKart
  ];
}
