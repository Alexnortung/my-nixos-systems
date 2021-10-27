{ pkgs, lib, config, ... }:

let
  myVscode = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      bbenoist.Nix
      james-yu.latex-workshop
      ms-vsliveshare.vsliveshare
      #ionide.ionide-fsharp
      ];
      #++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #  {
      #    name = "ionide-fsharp";
      #    publisher = "ionide";
      #    version = "5.5.5";
      #    sha256 = "";
      #  }
      #];
    };
in
{
  environment.systemPackages = [
    myVscode
  ];
}
