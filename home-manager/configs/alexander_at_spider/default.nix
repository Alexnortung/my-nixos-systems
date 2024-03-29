{ inputs, ... }:

let
  system = "x86_64-linux";
  pkgs = inputs.nixos-stable.legacyPackages.${system};
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    ../../profiles/nvim.nix
    # ../../profiles/eww
    ./home.nix
    ../../profiles/direnv.nix
    ../../profiles/git.nix
    inputs.oak-configs.homeManagerModules.ssh
  ];

  extraSpecialArgs = {
    inherit system inputs;
  };
}
