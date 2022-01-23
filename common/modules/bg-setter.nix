{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.bg-setter;
  #listOfTargets = [ "multi-user.target" ]
  #  ++ lists.optional config.services.autorandr.enable "autorandr.service";
  #listOfTargets = [ "multi-user.target" "autorandr.service" ];
  listOfTargets = [ "autorandr.service" ];
in
{
  options = {
    services.bg-setter = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable bg setter.
          bg-setter automatically sets your wallpaper after login and after autorandr change.
        '';
      };
      wallpaper = mkOption {
        default = "";
        type = types.str;
        description = ''
          The wallpapers to use
        '';
      };
      wallpaperSize = mkOption {
        default = "fill";
        type = types.enum [ "fill" "center" "max" "scale" "tile" ];
      };
      useFehBg = mkOption {
        default = true;
        description = ''
          Whether to save and use the state of saved fehbg.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.bg-setter = {
      description = ''
        Setting bg after login and autorandr
      '';
      serviceConfig = {
        PassEnvironment = "DISPLAY";
        Type = "oneshot";
      };
      unitConfig = {
      };
      # TODO: make sure that the script will check if the .fehbg file is present
      script = ''
        ${pkgs.feh}/bin/feh --bg-${cfg.wallpaperSize} ${optionalString (!cfg.useFehBg) "--no-fehbg"} ${cfg.wallpaper}
      '';
    };
  };
}
