{ inputs, ... }:

{
  nix.registry = {
    nixpkgs.flake = inputs.nixos-stable;
    unstable.flake = inputs.nixpkgs-unstable;
  };
}
