{
  channels = inputs@{ ... }: {
    nixos-spider.overlaysBuilder = import ./package-overlay.nix inputs;
  };
  host = input@{ nixos-hardware, ... }: {
    channelName = "nixos-spider";
    # Relative to flake.nix
    modules = [
      nixos-hardware.nixosModules.lenovo-thinkpad-x13
      ./configuration.nix
    ];
  };
}
