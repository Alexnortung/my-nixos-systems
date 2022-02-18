{
  channels = inputs@{ ... }: {
    nixos-enderman.overlaysBuilder = import ./package-overlay.nix inputs;
  };
  host = input@{ nur-alexnortung-enderman, ... }: {
    channelName = "nixos-enderman";
    # Relative to flake.nix
    modules = [
      ./configuration.nix
    ];
  };
}
