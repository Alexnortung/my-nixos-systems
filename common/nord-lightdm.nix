{ config, lib, pkgs, ...}:

{
  services.xserver.displayManager.lightdm = {
    greeters.gtk = {
      enable = true;
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
    };
  };
}
