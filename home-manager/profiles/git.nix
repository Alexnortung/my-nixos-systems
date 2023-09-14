{ lib, ... }@args:
let 
  config = (import ../../modules/git-config.nix args).programs.git.config;
in
{
  programs.git = {
    enable = true;
    aliases = config.alias;
    userEmail = lib.mkDefault config.user.email;
    userName = config.user.name;

    iniContent = {
      init = config.init;
      pull = config.pull;
      gpg.format = lib.mkDefault "ssh";
      commit.gpgsign = lib.mkDefault true;
    };
  };
}
