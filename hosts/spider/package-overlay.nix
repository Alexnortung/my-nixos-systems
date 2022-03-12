inputs@{ nur-alexnortung-spider, ... }:
channels: ((import ../../overlays/pre-master.nix).overlays channels) ++ [
  (import ../../overlays/shared-unstable.nix channels.nixpkgs)
  (import ../../overlays/default-unstable.nix channels.nixpkgs-unstable-spider)
  nur-alexnortung-spider.overlay
  (final: prev: {
    inherit (channels.nixpkgs-unstable-spider)
      nix # use nix unstable
      ;
  })
]
