{
  inputs = {
    nixos-boat.url = "github:NixOS/nixpkgs/386234e2a61e1e8acf94dfa3a3d3ca19a6776efb";
    nixpkgs-unstable-boat.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware-boat.url = "github:NixOS/nixos-hardware";
  };
  channels.nixos-boat.overlaysBuilder = import ./package-overlay.nix;
  host = input@{ nur-alexnortung-boat, nixos-hardware-boat, ... }: {
    channelName = "nixos-boat";
    # Relative to flake.nix
    modules = [
      nixos-hardware-boat.nixosModules.dell-latitude-3480
      ./configuration.nix
    ];
  };
}
