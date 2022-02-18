inputs@{ nur-alexnortung-enderman, ... }:
channels: [
  (import ../../overlays/default-unstable.nix channels.nixpkgs-unstable-enderman)
  ((import nur-alexnortung-enderman channels.nixos-enderman).overlay)
  (final: prev: {
    # inherit (channels.nixpkgs-unstable-boat)
    #   ;
  })
]
