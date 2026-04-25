{
  config,
  inputs,
  lib,
  system,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
  };
  localConfigPath = "${config.xdg.configHome}/opencode/local.jsonc";
in
{
  disabledModules = [
    "programs/opencode.nix"
  ];

  imports = [
    "${inputs.home-manager-unstable}/modules/programs/opencode.nix"
  ];

  programs.opencode = {
    enable = true;
    package = unstable.opencode;
    skills = ../../agents/skills;
    settings = {
      plugin = [ "oh-my-openagent" ];
    };
  };

  home.sessionVariables.OPENCODE_CONFIG = localConfigPath;

  xdg.configFile."opencode/oh-my-openagent.jsonc".source = ./oh-my-openagent.jsonc;
}
