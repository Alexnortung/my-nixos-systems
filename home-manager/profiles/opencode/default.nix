{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
  };
  localConfigPath = "${config.xdg.configHome}/opencode/local.jsonc";
  openagentscontrol = pkgs.callPackage ./oac2.nix { };
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
    agents = ../../agents/agents;
    settings = {
      plugin = [
        # "oh-my-openagent@3.17.5"
        "opencode-antigravity-auth@1.6.0"
        "@slkiser/opencode-quota@3.2.0"
        "@simonwjackson/opencode-direnv"
        "@tarquinen/opencode-dcp@3.1.9"
      ];
    };
  };

  home.sessionVariables.OPENCODE_CONFIG = localConfigPath;

  # xdg.configFile."opencode/oh-my-openagent.jsonc".source = ./oh-my-openagent.jsonc;

  # xdg.configFile."opencode/agent" = {
  #   source = "${openagentscontrol}/.config/opencode/agent";
  #   recursive = true;
  # };
  # xdg.configFile."opencode/command" = {
  #   source = "${openagentscontrol}/.config/opencode/command";
  #   recursive = true;
  # };
  # xdg.configFile."opencode/context" = {
  #   source = "${openagentscontrol}/.config/opencode/context";
  #   recursive = true;
  # };
  # xdg.configFile."opencode/skill" = {
  #   source = "${openagentscontrol}/.config/opencode/skill";
  #   recursive = true;
  # };
  # xdg.configFile."opencode/tool" = {
  #   source = "${openagentscontrol}/.config/opencode/tool";
  #   recursive = true;
  # };
}
