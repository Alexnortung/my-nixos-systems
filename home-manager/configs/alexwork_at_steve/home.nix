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
      permittedInsecurePackages = [
        "beekeeper-studio-5.1.5"
        "beekeeper-studio-5.2.12"
        "beekeeper-studio-5.3.4"
        "beekeeper-studio-5.5.3"
        "beekeeper-studio-5.5.5"
      ];
      allowUnfree = true;
    };
  };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "alexwork";
    homeDirectory = "/home/alexwork";
    packages = with pkgs; [
      unstable.slack
      imagemagick
      ripgrep
      nodejs
      bun
      unstable.yarn-berry
      nodePackages.pnpm
      unstable.beekeeper-studio
      gftp
      alacritty
      ffmpeg
      unstable.bruno
      unstable.obsidian
      unstable.mongodb-compass
      mongodb-tools
      unstable.gh
      unstable.spotify
      unstable.codex
      bubblewrap
      rclone
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;
  nixpkgs.overlays = [ inputs.coding-agents.overlays.default ];

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

  programs.git = {
    settings = {
      user.email = "alexander.nortung@oakdigital.dk";
    };
    iniContent = {
      commit.gpgsign = false;
      # gpg.format = { };
      # user.signingkey = { };
      # # gpg.format = false;
      # # user.signingkey = null;
    };
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      export PATH=$PATH:~/.node_modules/bin/
      export PATH="/home/alexander/.bun/bin:$PATH"
    '';
  };
}
