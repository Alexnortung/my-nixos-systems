{ config, lib, ... }:

{
  services.polybar = {
    enable = true;
    script = ''
      polybar main &
    '';
    settings = {
      "bar/main" = {
        height = "26pt";
        radius = 15;

        background = config.lib.stylix.colors.base00;

        padding-left = 0;
        padding-right = 0;

        module-margin = 1;

        separator = "|";
        separator-foreground = "#ffffff";

        # font-0 = JetBrainsMono Nerd Font


        cursor-click = "pointer";
        cursor-scroll = "ns-resize";

        enable-ipc = true;

        modules-left = "time";
        # modules-right = backlight wlan battery date
      };

      "module/time" = {
        type = "internal/date";
        interval = 1;

        label-background = "#E6cba6f7";
        label-padding = 2;
        date = "%I:%M %p";

        label = " %date%";
        label-foreground = "#ffffff";
      };
    };
  };
}
