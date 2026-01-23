{ pkgs, inputs, ... }:
let
  system = "x86_64-linux";
  unstable = import inputs.nixpkgs-factorio {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  services.factorio = {
    enable = true;
    package = unstable.factorio-headless;
    openFirewall = true;
    saveName = "v3";

    game-password = "kode";
  };
}
