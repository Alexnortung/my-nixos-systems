{ inputs, pkgs, lib, ... }:

let
  inherit (lib) mkForce;
  amixer = "${pkgs.alsa-utils}/bin/amixer";
in
{
  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
      background = mkForce {
        color = "rgba(25, 20, 20, 1.0)";
        path = "screenshot";
        blur_passes = 2;
        brightness = 0.5;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      input = {
        kb_layout = "dk";

        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        layout = "master";
      };

      monitor = [
        "eDP-1, 1920x1200@60, 0x0, 1"
        ",preferred,auto-left,1"
      ];

      decoration = {
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
        };
      };

      layerrule = [
        "blur,ironbar"
        "blur,rofi"
        "blur,notifications"
      ];

      master = {
        new_on_top = true;
        new_status = "master";
        mfact = 0.55;
        special_scale_factor = 1;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resize"
      ];

      bindl = [
        ", XF86AudioMute, exec, ${amixer} -q set Master toggle"
        ", XF86AudioMicMute, exec, ${amixer} -q set Capture toggle"
        ", XF86AudioPrev, exec, playerctl -p playerctld previous"
        ", XF86AudioNext, exec, playerctl -p playerctld next"
        ", XF86AudioPlay, exec, playerctl -p playerctld play-pause"
        ", XF86AudioPause, exec, playerctl -p playerctld pause"
      ];

      bindle = [
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86AudioLowerVolume, exec, ${amixer} -q set Master 3%-"
        ", XF86AudioRaiseVolume, exec, ${amixer} -q set Master 3%+"
      ];

      bind =
        [
          # Workspace/Layout
          "$mod SHIFT, Q, killactive"
          "$mod, TAB, workspace, previous"
          "$mod, Return, layoutmsg, swapwithmaster master"
          "$mod, H, splitratio, -0.05"
          "$mod, L, splitratio, +0.05"
          "$mod, M, fullscreen"
          "$mod, K, layoutmsg, cycleprev"
          "$mod, J, layoutmsg, cyclenext"

          "$mod, Comma, focusmonitor, l"
          "$mod, Period, focusmonitor, r"

          # Programs
          "$mod, F, exec, firefox"
          "$mod SHIFT, Return, exec, alacritty"
          ", Print, exec, grimblast --freeze copy area"
          "$mod ALT, L, exec, hyprlock"
          "$mod, Space, exec, killall rofi || rofi -show"
          ", code:179, exec, spotify"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList
            (i:
              let ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };

  services.hypridle = {
    enable = true;

    settings = {
      env = {
        HOME = "/home/alexander/";
      };

      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 200;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl set 0% --save";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl --restore";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 2000;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 2400;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
    };

    style = ''
      * {
        font-family: "Fira Code";
      }

      #clock {
        font-size: 16px;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "battery"
          "network"
          "tray"
        ];

        clock = {
          # format = "{:%H:%M}";
          # tooltip-format = "{:%Y-%m-%d}";
          # tooltip = true;
          format = "{:%R}";
          format-alt = "{:%Y %b %a %d %R}";
          tooltip = false;
        };

        "network" = {
          # "interface" = "wlp2*"; # (Optional) To force the use of this interface
          "interval" = 1;
          # "format-wifi" = "  {bandwidthTotalBytes =>2}"; #({essid} {signalStrength}%)
          # "format-ethernet" = "{ipaddr}/{cidr} ";
          # "tooltip-format-wifi" = " {ipaddr} ({signalStrength}%)";
          # "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "󰀦 Disconnected"; #Disconnected ⚠
          # "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };

        battery = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = " {capacity}%";
          "format-plugged" = " {capacity}%";
          "format-alt" = "{icon} {time}";
          # // "format-good": "", // An empty format will hide the module
          # // "format-full": "",
          "format-icons" = [ "" "" "" "" "" ];
        };
      };
    };
  };

  programs.hyprpanel = {
    # enable = true;

    layout = {
      "bar.layouts" = {
        "0" = {
          left = [ "dashboard" "workspaces" ];
          middle = [ "clock" ];
          right = [ "volume" "brightness" "battery" "bluetooth" "network" "systray" ];
        };
      };
    };

    settings = {
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      theme.bar.transparent = true;

      theme.font = {
        name = "CaskaydiaCove NF";
        size = "16px";
      };
    };
  };

  home.packages = with pkgs; [
    grimblast
    killall
    brightnessctl
    hyprpanel
  ];
}
