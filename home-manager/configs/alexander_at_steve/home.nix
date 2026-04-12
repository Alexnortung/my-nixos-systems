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
    username = "alexander";
    homeDirectory = "/home/alexander";
    packages = with pkgs; [
      unstable.wineWow64Packages.stableFull
      bottles
      unstable.winetricks
      # nodejs
      nodePackages.npm
      bun
      unstable.yarn-berry
      lmms
      bitwig-studio
      krita
      insomnia
      unstable.beekeeper-studio
      gftp
      unstable.prusa-slicer
      blender
      alacritty
      ffmpeg
      unstable.bruno
      unstable.webcord
      freecad
      kicad
      # legendary-gl
      heroic
      unstable.openscad-unstable
      unstable.obsidian
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  coding-agents.pi-coding-agent = {
    # enable = true;
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
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    settings = {
      user.email = "alex_nortung@live.dk";
    };
    iniContent = {
      gpg.format = "ssh";
      user.signingkey = "/home/alexander/.ssh/id_rsa.pub";
    };
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      export PATH=$PATH:~/.node_modules/bin/
      export PATH="/home/alexander/.bun/bin:$PATH"
      export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
    '';
  };
}
