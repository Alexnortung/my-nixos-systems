{ inputs, pkgs, lib, ... }:

let
  # spicetify = pkgs.callPackage (import "${inputs.spicetify}/package.nix" {
  #   inherit pkgs lib;
  #   theme = "Fluent";
  #   colorScheme = "Nord-Dark";
  # }) { };
in
{
  environment.systemPackages = [
    # (inputs.spicetify.defaultPackage.x86_64-linux.override {
    #   inherit pkgs lib;
    #   theme = "Fluent";
    #   colorScheme = "Nord-Dark";
    # })
    #inputs.spicetify.defaultPackage.x86_64-linux
    # spicetify
    (pkgs.spotify-spicified.override {
      theme = "Dribbblish";
      colorScheme = "Nord-Dark";
    })
  ];
}
