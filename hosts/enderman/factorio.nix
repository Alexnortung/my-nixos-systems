{ pkgs, inputs, ... }:
let
  system = "x86_64-linux";
  unstable = import inputs.nixpkgs-unstable-master { inherit system; config.allowUnfree = true; };
in
{
  services.factorio = {
    enable = true;
    package = unstable.factorio-headless;
    openFirewall = true;
    saveName = "v2";

    game-password = "kode";
  };
}
