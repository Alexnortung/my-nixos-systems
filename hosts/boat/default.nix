{
  channels = inputs@{ ... }: {
    nixos-boat.overlaysBuilder = import ./package-overlay.nix inputs;
  };
  host = input@{ nur-alexnortung-boat, nixos-hardware, ... }: let
    system = "x86_64-linux";
  in {
    inherit system;
    extraArgs = { inherit system; };
    channelName = "nixos-boat";
    # Relative to flake.nix
    modules = [
      nur-alexnortung-boat.nixosModules.autorandr
      nur-alexnortung-boat.nixosModules.zathura
      nixos-hardware.nixosModules.dell-latitude-3480
      ./configuration.nix
    ];
  };
}
