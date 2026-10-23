{
  inputs,
  pkgs,
  lib,
  system,
  ...
}:

let
  inherit (lib) mkForce;
  osd = "${pkgs.swayosd}/bin/swayosd-client";
  thunar = pkgs.thunar.override {
    thunarPlugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  clipboardPicker = pkgs.writeShellScript "clipboard-picker" ''
    ${pkgs.cliphist}/bin/cliphist list \
      | rofi -dmenu -p clipboard -display-columns 2 \
      | ${pkgs.cliphist}/bin/cliphist decode \
      | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
  };
in
{
  imports = [
    # inputs.hyprpanel.homeManagerModules.hyprpanel
  ];

  # Home Manager owns user-session behavior: Hyprland settings,
  # bars/idle/background services, and other per-user desktop prefs.
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

  # User-level Hyprland behavior stays here.
  wayland.windowManager.hyprland = {
    # # set the flake package
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # # make sure to also set the portal package, so that they are in sync
    # portalPackage =
    #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    # Set to null to use system
    package = null;
    portalPackage = null;
    enable = true;
    configType = "hyprlang";
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
        "eDP-1, 2560x1600@60.00Hz, 0x0, 1"
        ",preferred,auto-right,1"
      ];

      decoration = {
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
        };
      };

      layerrule = [
        "blur on, match:namespace ironbar"
        "blur on, match:namespace rofi"
        "blur on, match:namespace notifications"
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

      exec-once = [
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resize"
      ];

      bindl = [
        ", XF86AudioMute, exec, ${osd} --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, ${osd} --input-volume mute-toggle"
        ", XF86AudioPrev, exec, playerctl -p playerctld previous"
        ", XF86AudioNext, exec, playerctl -p playerctld next"
        ", XF86AudioPlay, exec, playerctl -p playerctld play-pause"
        ", XF86AudioPause, exec, playerctl -p playerctld pause"
      ];

      bindle = [
        ", XF86MonBrightnessDown, exec, ${osd} --brightness -5"
        ", XF86MonBrightnessUp, exec, ${osd} --brightness +5"
        ", XF86AudioLowerVolume, exec, ${osd} --output-volume -3"
        ", XF86AudioRaiseVolume, exec, ${osd} --output-volume +3"
      ];

      bind = [
        # Workspace/Layout
        "$mod SHIFT, Q, killactive"
        "$mod, TAB, workspace, previous"
        "$mod, Return, layoutmsg, swapwithmaster master"
        "$mod, H, layoutmsg, splitratio, -0.05"
        "$mod, L, layoutmsg, splitratio, +0.05"
        # "$mod, H, resizewindowpixel, -50"
        # "$mod, L, resizewindowpixel, 50"
        "$mod, M, fullscreen"
        "$mod, K, layoutmsg, cycleprev"
        "$mod, J, layoutmsg, cyclenext"
        "$mod SHIFT, T, togglefloating"

        "$mod, Comma, focusmonitor, l"
        "$mod, Period, focusmonitor, r"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Scratchpad
        "$mod, S, togglespecialworkspace, scratch"
        "$mod SHIFT, S, movetoworkspace, special:scratch"

        # Programs
        "$mod, F, exec, firefox"
        "$mod SHIFT, Return, exec, alacritty"
        "$mod, E, exec, thunar"
        ", Print, exec, grimblast --freeze copy area"
        "SHIFT, Print, exec, grimblast --freeze save area - | satty --filename - --copy-command wl-copy"
        "$mod, Print, exec, grimblast copy output"
        "$mod SHIFT, C, exec, hyprpicker --autocopy"
        "$mod, V, exec, killall rofi || ${clipboardPicker}"
        "$mod ALT, L, exec, hyprlock"
        "$mod SHIFT, E, exec, wlogout --protocol layer-shell"
        "$mod, Space, exec, killall rofi || rofi -show"
        "$mod SHIFT, Space, exec, killall rofi || rofi -show window"
        ", code:179, exec, spotify"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );

      windowrule =
        let
          winboatRegex = "(^winboat-.+$)|(^(xfreerdp|xfreerdp3)$)";
        in
        [
          "float on, match:class ^(wifitui_popup)$"
          "size 600 900, match:class ^(wifitui_popup)$"
          "center on, match:class ^(wifitui_popup)$"
          "dim_around on, match:class ^(wifitui_popup)$"

          "float on, match:class ${winboatRegex}"
          # "size 1400 1000, match:class ${winboatRegex}"
          "no_anim on, match:class ${winboatRegex}"
          "no_blur on, match:class ${winboatRegex}"
          "no_shadow on, match:class ${winboatRegex}"
          # Untitled RemoteApp helper windows (menus, the marker window): don't
          # focus them, focusing makes xfreerdp resend window geometry.
          "no_focus on, match:class ${winboatRegex}, match:title ^$"
        ];
      # windowrulev2 = [
      #   # Make the specific Alacritty instance float
      #   "float, class:^(wifitui_popup)$"
      #
      #   # Optional: Set a specific size for the pop-up (width height)
      #   "size 600 900, class:^(wifitui_popup)$"
      #
      #   # Optional: Force it to open in the center of the screen
      #   "center, class:^(wifitui_popup)$"
      #
      #   # Optional: Add a slight dim behind the popup to draw focus
      #   "dimaround, class:^(wifitui_popup)$"
      # ];

      env = [
        "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/gcr/ssh"
      ];
    };
  };

  # File manager on $mod+E. Thunar, xfconfd (its settings store) and tumblerd
  # (thumbnails) are D-Bus activated, so their D-Bus and systemd user units
  # have to be installed too.
  dbus.packages = [
    thunar
    pkgs.xfconf
    pkgs.tumbler
  ];
  systemd.user.packages = [
    pkgs.xfconf
    pkgs.tumbler
  ];
  # Thunar's bundled unit runs the binary without plugins, so define our own.
  systemd.user.services.thunar = {
    Unit.Description = "Thunar file manager";
    Service = {
      Type = "dbus";
      BusName = "org.xfce.FileManager";
      ExecStart = "${thunar}/bin/Thunar --daemon";
      KillMode = "process";
    };
  };

  # Graphical password prompts (e.g. mounting disks, gparted, pkexec).
  services.hyprpolkitagent.enable = true;

  # Clipboard history, picked with $mod+V.
  services.cliphist.enable = true;

  # On-screen display for volume/brightness keys.
  services.swayosd.enable = true;

  # Automount removable drives, with a tray icon.
  services.udiskie = {
    enable = true;
    tray = "auto";
  };

  # Night light.
  services.hyprsunset = {
    enable = true;
    settings.profile = [
      {
        time = "7:00";
        identity = true;
      }
      {
        time = "21:00";
        temperature = 4500;
      }
    ];
  };

  # Power menu on $mod+Shift+E.
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        # UWSM sessions should be stopped through uwsm; plain sessions just exit.
        action = "uwsm stop || hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
    ];
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
          timeout = 3800;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 4200;
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
          "pulseaudio"
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
          "format-wifi" = " {ipaddr} ({signalStrength}%)";
          "tooltip-format-wifi" = "  {bandwidthTotalBytes:>2}"; # ({essid} {signalStrength}%)
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "󰀦 Disconnected"; # Disconnected ⚠
          # "format-alt" = "{ifname}: {ipaddr}/{cidr}";

          on-click = "alacritty --class wifitui_popup -e wifitui";
          # Keep right click for alternating the text format if you like
          on-click-right = "mode";
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
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = " muted";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          scroll-step = 5;
          tooltip = false;
        };
      };
    };
  };

  # systemd.user.services = {
  #   waybar = {
  #     Unit = {
  #       After = mkForce [ "hyprland-session.target" ];
  #       PartOf = mkForce [ "hyprland-session.target" ];
  #     };
  #     Install = {
  #       WantedBy = mkForce [ "hyprland-session.target" ];
  #     };
  #   };
  #
  #   hypridle = {
  #     Unit = {
  #       After = mkForce [ "hyprland-session.target" ];
  #       PartOf = mkForce [ "hyprland-session.target" ];
  #     };
  #     Install = {
  #       WantedBy = mkForce [ "hyprland-session.target" ];
  #     };
  #   };
  #
  #   hyprpaper = {
  #     Unit = {
  #       After = mkForce [ "hyprland-session.target" ];
  #       PartOf = mkForce [ "hyprland-session.target" ];
  #     };
  #     Install = {
  #       WantedBy = mkForce [ "hyprland-session.target" ];
  #     };
  #   };
  # };

  # programs.hyprpanel = {
  #   # enable = true;
  #
  #   layout = {
  #     "bar.layouts" = {
  #       "0" = {
  #         left = [
  #           "dashboard"
  #           "workspaces"
  #         ];
  #         middle = [ "clock" ];
  #         right = [
  #           "volume"
  #           "brightness"
  #           "battery"
  #           "bluetooth"
  #           "network"
  #           "systray"
  #         ];
  #       };
  #     };
  #   };
  #
  #   settings = {
  #     bar.launcher.autoDetectIcon = true;
  #     bar.workspaces.show_icons = true;
  #
  #     menus.clock = {
  #       time = {
  #         military = true;
  #         hideSeconds = true;
  #       };
  #       weather.unit = "metric";
  #     };
  #
  #     menus.dashboard.directories.enabled = false;
  #     menus.dashboard.stats.enable_gpu = true;
  #
  #     theme.bar.transparent = true;
  #
  #     theme.font = {
  #       name = "CaskaydiaCove NF";
  #       size = "16px";
  #     };
  #   };
  # };

  home.packages = with pkgs; [
    unstable.wifitui
    thunar
    file-roller # Backend for thunar-archive-plugin
    grimblast
    satty
    hyprpicker
    wl-clipboard
    killall
    brightnessctl
    # hyprpanel
  ];
}
