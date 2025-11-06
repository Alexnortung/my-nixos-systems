{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gcalcli
    ];
  };
  systemd.user = {
    services.gcalcli-remind = {
      Unit = {
        Description = "Google Calendar CLI Reminder Service";
        Wants = [
          "network-online.target"
          "graphical-session.target"
        ];
        After = [
          "network-online.target"
          "graphical-session.target"
        ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.gcalcli}/bin/gcalcli remind 1";
      };
    };

    timers.gcalcli-remind = {
      Unit = {
        Description = "Run gcalcli remind every minute";
      };
      Timer = {
        # This syntax means "at every minute"
        OnCalendar = "*:0/1";
        Persistent = true; # Run once on boot if it was missed
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
