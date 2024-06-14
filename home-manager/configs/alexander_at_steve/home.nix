{ config
, pkgs
, inputs
, system
, ...
}:
let
  unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "alexander";
    homeDirectory = "/home/alexander";
    packages = with pkgs; [
      nodejs
      nodePackages.npm
      unstable.yarn-berry
      lmms
      krita
      edgedb
      insomnia
      beekeeper-studio
      gftp
      prusa-slicer
      blender
      alacritty
      ffmpeg
      unstable.bruno
      unstable.webcord
      freecad
      kicad
      # legendary-gl
      heroic
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

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
    difftastic.enable = true;
    userEmail = "alexander.nortung@oakdigital.dk";
    iniContent = {
      gpg.format = "ssh";
      user.signingkey = "/home/alexander/.ssh/id_rsa.pub";
    };
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      export PATH=$PATH:~/.node_modules/bin/
      export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
    '';
  };
}
