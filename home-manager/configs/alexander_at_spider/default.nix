{ inputs, ... }:

let 
  system = "x86_64-linux";
  pkgs = inputs.nixos-stable.legacyPackages.${system};
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    # inputs.nixvim.homeManagerModules.nixvim
    ../../profiles/nvim.nix
    ../../profiles/eww
    ./home.nix
    ../../profiles/direnv.nix
  ];

  extraSpecialArgs = {
    inherit system inputs;
  };
}
