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
      webcord
      tenacity
      # sherloq
      # unstable.zed-editor
      unstable.infisical
      unstable.doctl
      act
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

  programs.git = {
    userEmail = "alexander.nortung@oakdigital.dk";
    iniContent = {
      gpg.format = "ssh";
      user.signingkey = "/home/alexander/.ssh/id_rsa.pub";
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      export PNPM_HOME="/home/alexander/.local/share/pnpm"
      export PATH="$PATH:$PNPM_HOME"
      export PATH=$PATH:~/mutable_node_modules/bin/
    '';
  };

  programs.kitty.enable = true; # required for the default Hyprland config

  # Optional, hint Electron apps to use Wayland:
  # home.sessionVariables.NIXOS_OZONE_WL = "1";
}
