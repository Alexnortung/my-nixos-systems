{
  inputs = {
    nixos-boat.url = "github:NixOS/nixpkgs/386234e2a61e1e8acf94dfa3a3d3ca19a6776efb";
    nixpkgs-unstable-boat.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware-boat.url = "github:NixOS/nixos-hardware";
  };
  host = input@{ nur-alexnortung-boat, ... }: {
    channelName = "nixos-boat";
    # Relative to flake.nix
    modules = [
      ./hosts/boat/configuration.nix
    ];
  };
}
