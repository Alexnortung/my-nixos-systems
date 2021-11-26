{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.batteryNotifier;
in
{
  options = {
    services.batteryNotifier = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable battery notifier.
        '';
      };
      device = mkOption {
        default = "BAT0";
        description = ''
          Device to monitor.
        '';
      };
      notifyCapacity = mkOption {
        default = 10;
        description = ''
          Battery level at which a notification shall be sent.
        '';
      };
      hibernateCapacity = mkOption {
        default = 5;
        description = ''
          Battery level at which a hibernate unless connected shall be sent.
        '';
      };
      tmpFilePath = mkOption {
        default = "/tmp/batteryNotifier";
        description = ''
          A temporary file that the user should have read and write access to.
          The file name will be concatenated with a dash and the name of the user.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.timers."lowbatt" = {
      description = "check battery level";
      timerConfig.OnBootSec = "1m";
      timerConfig.OnUnitInactiveSec = "1m";
      timerConfig.Unit = "lowbatt.service";
      wantedBy = ["timers.target"];
    };
    systemd.user.services."lowbatt" = {
      description = "battery level notifier";
      serviceConfig.PassEnvironment = "DISPLAY";
      script = ''
        export battery_capacity=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/${cfg.device}/capacity)
        export battery_status=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/${cfg.device}/status)
        export tmp_file_name="${cfg.tmpFilePath}-$(${pkgs.coreutils}/bin/whoami).tmp"
        if [[ $battery_status -ne "Discharging" ]]; then
            rm -f ${cfg.tmpFilePath}
        fi
        if [[ $battery_capacity -le ${builtins.toString cfg.notifyCapacity} && $battery_status = "Discharging" ]]; then
            if [ -f "$tmp_file_name" ]; then
                sleep 1s
            else
                ${pkgs.libnotify}/bin/notify-send --urgency=critical --hint=int:transient:1 --icon=battery_empty "Battery Low" "You should probably plug-in."
                touch $tmp_file_name
            fi
        fi
        if [[ $battery_capacity -le ${builtins.toString cfg.hibernateCapacity} && $battery_status = "Discharging" ]]; then
            ${pkgs.libnotify}/bin/notify-send --urgency=critical --hint=int:transient:1 --icon=battery_empty "Battery Critically Low" "Computer will hibernate in 60 seconds."
            sleep 60s
            battery_status=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/${cfg.device}/status)
            if [[ $battery_status = "Discharging" ]]; then
                systemctl hibernate
            fi
        fi
      '';
    };
  };
}
