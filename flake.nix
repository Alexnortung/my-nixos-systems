{
  description = "Alexnortung's system configurations and server configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-boat.url = "github:NixOS/nixpkgs/386234e2a61e1e8acf94dfa3a3d3ca19a6776efb";
    nixpkgs-enderman.url = "github:NixOS/nixpkgs/8588b14a397e045692d0a87192810b6dddf53003";
    nixpkgs-spider.url = "github:NixOS/nixpkgs/b3d86c56c786ad9530f1400adbd4dfac3c42877b";
    #nixpkgs-steve.url = "github:NixOS/nixpkgs/nixos-21.11";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nur-alexnortung.url = "github:alexnortung/nur-alexnortung";

    hardware-rep.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixpkgs-boat, ... }@inputs: {
    nixosConfigurations = import ./systems inputs;
    # nixosConfigurations.boat = nixpkgs-boat.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [
    #     ./systems/boat/configuration.nix
    #   ];
    # };

    lib = import ./lib inputs;
  };
}
