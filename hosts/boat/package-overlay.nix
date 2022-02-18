inputs@{ nur-alexnortung-boat, ... }:
channels: ((import ../../overlays/pre-master.nix).overlays channels) ++ [
  (import ../../overlays/default-unstable.nix channels.nixpkgs-unstable-boat)
  nur-alexnortung-boat.overlay
  (final: prev: {
    inherit (channels.nixpkgs-unstable-boat)
      nix # use nix unstable
      ;
  })
]
