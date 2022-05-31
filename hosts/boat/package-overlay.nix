inputs@{ nur-alexnortung-boat, ... }:
channels: ((import ../../overlays/pre-master.nix).overlays channels) ++ [
  (import ../../overlays/default-unstable.nix channels.nixpkgs-unstable-boat) # dont use this if on nixos-unstable
  nur-alexnortung-boat.overlay
  (final: prev: {
    inherit (channels.nixpkgs-unstable-boat)
      nix # use nix unstable
      ;
  })
]
