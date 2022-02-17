channels: [
  (import ../../overlays/default-unstable.nix channels.nixpkgs-unstable-boat)
  (final: prev: {
    inherit (channels.unstable-nixpkgs-boat)
      nix # use nix unstable
      ;
  })
]
