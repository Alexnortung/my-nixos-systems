{
  config,
  pkgs,
  inputs,
  system,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "beekeeper-studio-5.2.12"
        "beekeeper-studio-5.5.3"
        "beekeeper-studio-5.3.4"
        "beekeeper-studio-5.5.5"
        "beekeeper-studio-5.5.7"
      ];
    };
  };
  phpConfigured = pkgs.php.buildEnv {
    extraConfig = ''
      memory_limit = 2G;
    '';
  };
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.2.12"
  ];
  stylix.targets.gnome.enable = false;
  stylix.targets.firefox.profileNames = [ "default" ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "alexander";
    homeDirectory = "/home/alexander";
    packages = with pkgs; [
      nodejs
      unstable.bun
      phpConfigured
      unstable.mongodb-compass
      mongodb-tools
      # nodePackages.npm
      nodePackages.pnpm
      yarn-berry
      # nodePackages.serverless
      # mysql
      phpPackages.composer
      # fluxcd
      rclone
      insomnia
      alacritty
      unstable.bruno
      jq
      # webcord
      # tenacity
      # sherloq
      # unstable.zed-editor
      unstable.infisical
      unstable.doctl
      unstable.beekeeper-studio
      act
      gh
      ripgrep
      unstable.devenv
      unstable.playwright
      unstable.slack
      imagemagick
      unstable.bitwarden-desktop
      unstable.spotify
      # unstable.obsidian
      cowsay
      gcalcli
      libnotify
      btop
      unstable.codex
      unstable.antigravity-fhs
      # Antigravity is using sanbox-exec
      (writeShellScriptBin "sandbox-exec" ''
        # Loop through arguments and strip sandbox-exec specific flags
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -f|-n|-p|-D) 
              shift 2 ;; # Shift the flag and its argument
            -*) 
              shift 1 ;; # Shift any other rogue flags
            *) 
              break ;;   # Stop when we hit the actual command
          esac
        done

        # Execute the raw command
        exec "$@"
      '')
    ];

    shellAliases = {
      # npm = "pnpm";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  programs.firefox = {
    enable = true;
    package = unstable.firefox;

    profiles.default = {
      id = 0;
      path = "fkcoc1l0.default";
      settings = {
        "layout.css.prefers-color-scheme.content-override" = 0;
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.dark-private-windows" = true;
      };
    };
  };

  programs.git = {
    iniContent = {
      gpg.format = "ssh";
      user.signingkey = "/home/alexander/.ssh/id_rsa.pub";
    };
    settings = {
      user.email = "alexander.nortung@oakdigital.dk";
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      export PNPM_HOME="/home/alexander/.local/share/pnpm"
      export PATH="$PATH:$PNPM_HOME"
      export PATH=$PATH:~/mutable_node_modules/bin/

      alias dnvim='nix run ~/source/nollevim'
      ${./goodmorning.sh}
    '';
  };

  programs.kitty.enable = true; # required for the default Hyprland config

  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_width = 1;
        padding = 16;
        horizontal_padding = 16;
        origin = "top-right";
      };
      urgency_critical = {
        origin = "center";
        width = 300;
        script = "${./alert.sh}";
      };

      # play_sound = {
      #   stack_tag = "play_sound";
      #   summary = "";
      #   script = "${./alert.sh}";
      # };
    };
  };

  # Optional, hint Electron apps to use Wayland:
  # home.sessionVariables.NIXOS_OZONE_WL = "1";
}
