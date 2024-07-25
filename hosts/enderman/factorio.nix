{ pkgs, inputs, ... }:
let
  system = "x86_64-linux";
  unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
in
{
  services.factorio = {
    enable = true;
    package = unstable.factorio-headless;
    openFirewall = true;

    game-password = "Patrick skal se serie";
  };
}
