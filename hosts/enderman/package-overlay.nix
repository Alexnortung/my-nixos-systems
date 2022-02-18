inputs@{ nur-alexnortung-enderman, ... }:
channels: [
  (import ../../overlays/default-unstable.nix channels.nixpkgs-unstable-enderman)
  nur-alexnortung-enderman.overlay
  (final: prev: {
    # inherit (channels.nixpkgs-unstable-boat)
    #   ;
  })
]
