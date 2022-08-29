{ inputs, ... }:

{
  nix.registry = {
    nixpkgs.flake = inputs.nixos-stable;
    unstable.flake = inputs.nixos-unstable;
  };
}
