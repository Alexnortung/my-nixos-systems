{ lib
, config
, ...
}:

let
  # Unstable
  pkgs = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    rev = "47f45c8440e2ef1e967aa5aec3528dd976c4a488";
  }) { 
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "vscode-extension-ms-vsliveshare-vsliveshare"
        "vscode-extension-ms-vscode-cpptools"
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
      arcticicestudio.nord-visual-studio-code
      ms-vscode.cpptools
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
