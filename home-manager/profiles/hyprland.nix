{
  config,
  inputs,
  pkgs,
  lib,
  system,
  ...
}:

let
  inherit (lib) mkForce;
  # Stylix palette (oxocarbon), without leading '#'.
  c = config.lib.stylix.colors;
  monoFont = config.stylix.fonts.monospace.name;
  cursor = config.home.pointerCursor;
  bluetoothPopup = "alacritty --class bluetui_popup -e bluetui";
  # Power menu, shared by the keybind, waybar and swaync.
  powerMenu = pkgs.writeShellScriptBin "power-menu" ''
    pkill -x wlogout || exec ${pkgs.wlogout}/bin/wlogout --protocol layer-shell --buttons-per-row 3 --column-spacing 16 --row-spacing 16
  '';
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

      input-field = {
        size = "320, 52";
        position = "0, -80";
        halign = "center";
        valign = "center";
        rounding = 12;
        outline_thickness = 2;
        outer_color = mkForce "rgb(${c.base0D}) rgb(${c.base0E}) 45deg";
        fade_on_empty = false;
        dots_center = true;
        placeholder_text = "Password";
        font_family = monoFont;
      };

      label = [
        {
          text = "cmd[update:1000] date +%H:%M";
          font_size = 110;
          font_family = monoFont;
          color = "rgb(${c.base05})";
          position = "0, 220";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:60000] date '+%A %d %B'";
          font_size = 22;
          font_family = monoFont;
          color = "rgb(${c.base04})";
          position = "0, 110";
          halign = "center";
          valign = "center";
        }
      ];
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
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = mkForce "rgb(${c.base0D}) rgb(${c.base0E}) 45deg";
        "col.inactive_border" = mkForce "rgb(${c.base02})";
      };

      monitor = [
        "eDP-1, 2560x1600@60.00Hz, 0x0, 1"
        ",preferred,auto-right,1"
      ];

      decoration = {
        rounding = 10;
        dim_inactive = true;
        dim_strength = 0.05;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          vibrancy = 0.2;
        };
        shadow = {
          enabled = true;
          range = 16;
          render_power = 3;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "smooth, 0.25, 1, 0.5, 1"
          "overshoot, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 4, smooth, popin 85%"
          "windowsOut, 1, 4, smooth, popin 85%"
          "border, 1, 8, default"
          "fade, 1, 5, smooth"
          "layers, 1, 4, smooth, fade"
          "workspaces, 1, 5, smooth, slide"
          "specialWorkspace, 1, 5, smooth, slidevert"
        ];
      };

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      layerrule = [
        "blur on, match:namespace rofi"
        "ignore_alpha 0.3, match:namespace rofi"
        "blur on, match:namespace swaync-control-center"
        "blur on, match:namespace swaync-notification-window"
        "ignore_alpha 0.3, match:namespace swaync-.*"
        "blur on, match:namespace logout_dialog"
        "blur on, match:namespace swayosd"
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
        "hyprctl setcursor ${cursor.name} ${toString cursor.size}"
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
        "$mod, N, exec, swaync-client -t -sw"
        "$mod, B, exec, ${bluetoothPopup}"
        "$mod SHIFT, E, exec, ${powerMenu}/bin/power-menu"
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

          "float on, match:class ^(bluetui_popup)$"
          "size 900 600, match:class ^(bluetui_popup)$"
          "center on, match:class ^(bluetui_popup)$"
          "dim_around on, match:class ^(bluetui_popup)$"

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
        # Home Manager only puts these in the shell profile, which UWSM
        # doesn't read, so Hyprland fell back to its built-in cursor.
        "XCURSOR_THEME,${cursor.name}"
        "XCURSOR_SIZE,${toString cursor.size}"
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

  programs.wlogout.style = ''
    * {
      background-image: none;
      box-shadow: none;
      font-family: "${monoFont}";
    }
    window {
      background-color: alpha(#${c.base00}, 0.6);
    }
    button {
      color: #${c.base05};
      background-color: #${c.base01};
      border: 2px solid #${c.base02};
      border-radius: 16px;
      background-repeat: no-repeat;
      background-position: center 40%;
      background-size: 30%;
    }
    button:focus, button:hover {
      background-color: #${c.base02};
      border-color: #${c.base0D};
    }
    #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
    #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
    #suspend { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
    #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
    #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
    #hibernate { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png")); }
  '';

  services.swayosd.stylePath = pkgs.writeText "swayosd.css" ''
    window#osd {
      border-radius: 999px;
      border: 2px solid #${c.base02};
      background: alpha(#${c.base00}, 0.9);
      padding: 12px 20px;
    }
    window#osd * {
      color: #${c.base05};
    }
    window#osd progressbar trough {
      background: #${c.base02};
      border-radius: 999px;
      min-height: 6px;
    }
    window#osd progressbar progress {
      background: #${c.base0D};
      border-radius: 999px;
      min-height: 6px;
    }
  '';

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

  # Stylix provides the @baseXX colors and font; the layout CSS is ours.
  stylix.targets.waybar.addCss = false;

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: @base00;
        color: @base05;
        border: 2px solid @base02;
        border-radius: 12px;
      }

      tooltip {
        background: @base01;
        border: 1px solid @base0D;
        border-radius: 8px;
      }

      #workspaces {
        margin: 4px 6px;
      }
      #workspaces button {
        padding: 0 8px;
        margin: 0 2px;
        border-radius: 8px;
        color: @base04;
        background: transparent;
      }
      #workspaces button:hover {
        background: @base02;
        color: @base05;
      }
      #workspaces button.active {
        background: @base0D;
        color: @base00;
      }
      #workspaces button.urgent {
        background: @base08;
        color: @base00;
      }

      #window {
        color: @base04;
        margin-left: 8px;
      }

      #clock {
        font-weight: bold;
      }

      #clock, #cpu, #memory, #pulseaudio, #backlight, #bluetooth,
      #network, #battery, #tray, #custom-notification, #custom-power {
        padding: 0 10px;
      }

      #cpu { color: @base0C; }
      #memory { color: @base0E; }
      #pulseaudio { color: @base0D; }
      #pulseaudio.muted { color: @base03; }
      #backlight { color: @base0A; }
      #bluetooth { color: @base0F; }
      #network { color: @base0B; }
      #network.disconnected { color: @base08; }
      #battery.charging, #battery.plugged { color: @base0B; }
      #battery.warning:not(.charging) { color: @base0A; }
      #battery.critical:not(.charging) { color: @base08; }
      #custom-power {
        color: @base08;
        margin-right: 4px;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        # Detached from the screen edges; matches Hyprland's gaps_out.
        margin-top = 8;
        margin-left = 8;
        margin-right = 8;
        spacing = 0;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "pulseaudio"
          "backlight"
          "bluetooth"
          "network"
          "battery"
          "custom/notification"
          "custom/power"
        ];

        "hyprland/window" = {
          format = "{title}";
          max-length = 60;
          separate-outputs = true;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%a %d %b  %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            weeks-pos = "left";
            format = {
              today = "<span color='#${c.base0D}'><b>{}</b></span>";
              weeks = "<span color='#${c.base03}'>W{}</span>";
            };
          };
        };

        cpu = {
          format = "󰻠 {usage}%";
          interval = 5;
        };

        memory = {
          format = "󰍛 {percentage}%";
          interval = 5;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 muted";
          format-icons.default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          scroll-step = 5;
          tooltip = false;
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
        };

        bluetooth = {
          format = "󰂯";
          format-connected = "󰂱 {num_connections}";
          format-off = "󰂲";
          format-disabled = "󰂲";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
          on-click = bluetoothPopup;
          on-click-right = "blueman-manager";
        };

        network = {
          interval = 5;
          format-wifi = "󰤨 {essid}";
          format-ethernet = "󰈀 {ipaddr}";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰤭 Disconnected";
          tooltip-format-wifi = "{ipaddr} ({signalStrength}%)\n{bandwidthTotalBytes}";
          tooltip-format = "{ifname} via {gwaddr}";
          on-click = "alacritty --class wifitui_popup -e wifitui";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            "󰁺"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰁹"
          ];
        };

        # Bell for swaync; hidden on hosts without it.
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            none = "󰂚";
            notification = "<span color='#${c.base08}'>󱅫</span>";
            dnd-none = "󰂛";
            dnd-notification = "󰂛";
            inhibited-none = "󰂚";
            inhibited-notification = "<span color='#${c.base08}'>󱅫</span>";
            dnd-inhibited-none = "󰂛";
            dnd-inhibited-notification = "󰂛";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/power" = {
          format = "󰐥";
          tooltip = false;
          on-click = "${powerMenu}/bin/power-menu";
        };

        tray = {
          spacing = 8;
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
    bluetui
    powerMenu
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
