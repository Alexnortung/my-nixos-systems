{ lib
, config
, ...
}:

let
  # Unstable
  pkgs = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    rev = "931ab058daa7e4cd539533963f95e2bb0dbd41e6";
  }) { 
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "vscode-extension-ms-vsliveshare-vsliveshare"
      ];
    };
  };
in
let
  marketPlaceExtensions = [
    #{
    #  name = "codeTogether";
    #  publisher = "genuitecllc";
    #  version = "5.0.1";
    #  sha256 = "sha256:0pcw3sqw84w6j9f6y1bzmw7fi0vihc5zyyj3c4mmnkhzh5wg84bx";
    #}
  ];
  vscodeExtensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      bbenoist.nix
      james-yu.latex-workshop
      ms-vsliveshare.vsliveshare
  ];
in
let
  myVscode = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = vscodeExtensions ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace marketPlaceExtensions);
  };
in
{
  environment.systemPackages = [
    myVscode
  ];
}
