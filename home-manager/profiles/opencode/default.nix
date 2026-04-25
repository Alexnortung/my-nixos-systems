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
  };
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
  };
}
