{
  channels = inputs@{ ... }: {
    nixos-spider.overlaysBuilder = import ./package-overlay.nix inputs;
  };
  host = input@{ nur-alexnortung-spider, nixos-hardware, ... }: {
    channelName = "nixos-spider";
    # Relative to flake.nix
    modules = [
      nur-alexnortung-spider.nixosModules.autorandr
      nixos-hardware.nixosModules.lenovo-thinkpad-x13
      ./configuration.nix
    ];
  };
}
