{ pkgs, ... }:

{

  programs.hyprlock = {
    enable = true;
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

          # Programs
          "$mod, F, exec, firefox"
          "$mod SHIFT, Return, exec, alacritty"
          ", Print, exec, grimblast --freeze copy area"
          "$mod ALT, L, exec, hyprlock"
          "$mod, Space, exec, killall rofi || rofi -show"
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

  home.packages = with pkgs; [
    grimblast
    killall
  ];
}
