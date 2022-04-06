inputs@{ nur-alexnortung-steve, ... }:
channels: ((import ../../overlays/pre-master.nix).overlays channels) ++ [
  (import ../../overlays/shared-unstable.nix channels.nixpkgs)
  (import ../../overlays/default-unstable.nix channels.nixpkgs-unstable-steve)
  nur-alexnortung-steve.overlay
  (final: prev: {
    inherit (channels.nixpkgs-unstable-steve)
      nix # use nix unstable
      ;
  })
]
