{ inputs, ... }:

let 
  system = "x86_64-linux";
  pkgs = inputs.nixos-spider.legacyPackages.${system};
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    inputs.nixvim.homeManagerModules.nixvim
    ../../profiles/nvim.nix
    ./home.nix
  ];

  extraSpecialArgs = {
    inherit system inputs;
  };
}
