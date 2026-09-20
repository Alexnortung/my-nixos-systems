{
  lib,
  inputs,
  system,
  ...
}@args:
let
  unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  programs.difftastic.enable = true;
  programs.difftastic.git.enable = true;

  programs.lazygit = {
    enable = true;
    package = unstable.lazygit;
    settings = {
      git = {
        diffRenderers = [
          {
            # useConfig = true;
            colorArg = "always";
            type = "extDiff";
            command = "difft --color=always";
          }
        ];
      };
    };
  };
}
