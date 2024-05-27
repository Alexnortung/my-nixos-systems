{ lib, inputs, system, ... }@args:
let
  unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  programs.git.difftastic.enable = true;

  programs.lazygit = {
    enable = true;
    package = unstable.lazygit;
    settings = {
      git = {
        paging = {
          # useConfig = true;
          colorArg = "always";
          externalDiffCommand = "difft --color=always";
        };
      };
    };
  };
}
