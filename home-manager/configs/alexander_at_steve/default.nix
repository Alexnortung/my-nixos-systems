{ inputs, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixos-stable { inherit system; config.allowUnfree = true; };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    # inputs.nixvim.homeManagerModules.nixvim
    ../../profiles/nvim.nix
    ./home.nix
    ../../profiles/direnv.nix
  ];

  extraSpecialArgs = {
    inherit system inputs;
  };
}
