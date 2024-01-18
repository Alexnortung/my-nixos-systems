{ inputs, ... }:

{
  nix.registry = {
    # nixpkgs.flake = inputs.nixos-stable;
    # nixpkgs.exact = true;
    unstable.flake = inputs.nixpkgs-unstable;
    # home-manager.flake = inputs.home-manager;
  };
}
