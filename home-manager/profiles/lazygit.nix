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
        pagers = [
          {
            # useConfig = true;
            colorArg = "always";
            externalDiffCommand = "difft --color=always";
          }
        ];
      };
    };
  };
}
