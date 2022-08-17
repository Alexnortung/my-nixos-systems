{
  channels = inputs@{ ... }: {
    nixos-boat.overlaysBuilder = import ./package-overlay.nix inputs;
  };
  host = input@{ nixos-hardware, ... }: let
    system = "x86_64-linux";
  in {
    inherit system;
    extraArgs = { inherit system; };
    channelName = "nixos-boat";
    # Relative to flake.nix
    modules = [
      nixos-hardware.nixosModules.dell-latitude-3480
      ./configuration.nix
    ];
  };
}
