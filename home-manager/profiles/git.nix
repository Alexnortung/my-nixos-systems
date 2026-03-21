{ lib, ... }@args:
let
  config = (import ../../modules/git-config.nix args).programs.git.config;
in
{
  imports = [
    ./lazygit.nix
  ];

  programs.git = {
    enable = true;
    settings = {
      alias = config.alias;
      user.email = lib.mkDefault config.user.email;
      user.name = lib.mkDefault config.user.name;
    };

    iniContent = {
      init = config.init;
      pull = config.pull;
      gpg.format = lib.mkDefault "ssh";
      commit.gpgsign = lib.mkDefault true;
    };
  };
}
