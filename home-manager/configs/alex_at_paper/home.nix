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
  winboatWord = pkgs.writeShellApplication {
    name = "winboat-word";
    runtimeInputs = with pkgs; [
      coreutils
      docker
      freerdp
      yq-go
    ];
    text = ''
      set -eu

      compose_file=""
      for candidate in \
        "''${WINBOAT_DIR:-}" \
        "''${HOME}/.winboat" \
        "''${HOME}/winboat" \
        "''${HOME}/.local/share/winboat"
      do
        [ -n "$candidate" ] || continue
        if [ -f "$candidate/docker-compose.yml" ]; then
          compose_file="$candidate/docker-compose.yml"
          break
        fi
      done

      if [ -z "$compose_file" ]; then
        printf '%s\n' "WinBoat compose file not found. Checked WINBOAT_DIR, ~/.winboat, ~/winboat, and ~/.local/share/winboat." >&2
        exit 1
      fi

      username="$(yq '.services.windows.environment.USERNAME' "$compose_file")"
      password="$(yq '.services.windows.environment.PASSWORD' "$compose_file")"

      if [ -z "$username" ] || [ "$username" = "null" ] || [ -z "$password" ] || [ "$password" = "null" ]; then
        printf '%s\n' "WinBoat credentials are missing from $compose_file." >&2
        exit 1
      fi

      rdp_port="$(docker port WinBoat 3389/tcp | awk -F: 'NR == 1 { print $NF }')"
      if [ -z "$rdp_port" ]; then
        printf '%s\n' "Could not determine the WinBoat RDP port. Is the WinBoat container running?" >&2
        exit 1
      fi

      if [ -n "''${WAYLAND_DISPLAY:-}" ] && command -v wlfreerdp >/dev/null 2>&1; then
        rdp_bin="$(command -v wlfreerdp)"
      elif command -v xfreerdp3 >/dev/null 2>&1; then
        rdp_bin="$(command -v xfreerdp3)"
      else
        rdp_bin="$(command -v xfreerdp)"
      fi

      app_args=""
      if [ "$#" -gt 0 ]; then
        file_path="$(realpath "$1")"
        file_dir="$(dirname "$file_path")"
        file_name="$(basename "$file_path")"
        windows_file="\\\\tsclient\\linux\\$file_name"
        app_args=",cmd:\"$windows_file\""

        exec "$rdp_bin" \
          "/u:$username" \
          "/p:$password" \
          /v:127.0.0.1 \
          "/port:$rdp_port" \
          /cert:ignore \
          +clipboard \
          /sound:sys:pulse \
          /microphone:sys:pulse \
          /compression \
          /gdi:sw \
          +geometry \
          /mouse:grab:off \
          -grab-mouse \
          -toggle-fullscreen \
          -wallpaper \
          /size:1400x1000 \
          /scale-desktop:100 \
          /wm-class:winboat-MicrosoftWord \
          "/drive:linux,$file_dir" \
          "/app:program:C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE,name:MicrosoftWord$app_args"
      fi

      exec "$rdp_bin" \
        "/u:$username" \
        "/p:$password" \
        /v:127.0.0.1 \
        "/port:$rdp_port" \
        /cert:ignore \
        +clipboard \
        /sound:sys:pulse \
        /microphone:sys:pulse \
        /compression \
        /gdi:sw \
        +geometry \
        /mouse:grab:off \
        -grab-mouse \
        -toggle-fullscreen \
        -wallpaper \
        /size:1400x1000 \
        /scale-desktop:100 \
        /wm-class:winboat-MicrosoftWord \
        '/app:program:C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE,name:MicrosoftWord'
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

  programs.alacritty = {
    enable = true;
    settings = {
      keyboard = {
        bindings = [
          {

            key = "Return";
            mods = "Control|Shift";
            action = "SpawnNewInstance";
          }
        ];
      };
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "alex";
    homeDirectory = "/home/alex";
    packages = with pkgs; [
      unstable.winboat
      freerdp
      winboatWord
      nodejs
      unstable.bun
      phpConfigured
      unstable.mongodb-compass
      mongodb-tools
      pnpm
      yarn-berry
      phpPackages.composer
      rclone
      unstable.bruno
      jq
      unstable.beekeeper-studio
      act
      gh
      ripgrep
      unstable.playwright
      unstable.slack
      imagemagick
      unstable.bitwarden-desktop
      unstable.spotify
      cowsay
      # gcalcli
      libnotify
      btop
      unstable.opencode
      bubblewrap
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
  home.stateVersion = "25.11";

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

  xdg = {
    enable = true;
    desktopEntries.microsoft-word-winboat = {
      categories = [
        "Office"
        "WordProcessor"
      ];
      exec = "${winboatWord}/bin/winboat-word %f";
      genericName = "Word Processor";
      icon = "winboat";
      mimeType = [
        "application/msword"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      ];
      name = "Microsoft Word (WinBoat)";
      settings = {
        StartupWMClass = "winboat-MicrosoftWord";
      };
      terminal = false;
      type = "Application";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/msword" = [ "microsoft-word-winboat.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "microsoft-word-winboat.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
    };
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
      # gpg.format = "ssh";
      # user.signingkey = "/home/alex/.ssh/id_rsa.pub";
      commit.gpgsign = false;
    };
    settings = {
      user.email = "an@dokumenter.dk";
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
      # urgency_critical = {
      #   origin = "center";
      #   width = 300;
      #   script = "${./alert.sh}";
      # };

      # play_sound = {
      #   stack_tag = "play_sound";
      #   summary = "";
      #   script = "${./alert.sh}";
      # };
    };
  };

  home.sessionVariables = {
    # Native Wayland is required for reliable screen sharing in Hyprland.
    BROWSER = "firefox";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };
}
