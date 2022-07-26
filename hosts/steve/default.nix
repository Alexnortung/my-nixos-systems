{
  channels = inputs@{ ... }: {
    nixos-steve.overlaysBuilder = import ./package-overlay.nix inputs;
  };
  host = input@{ nur-alexnortung-steve, nixos-hardware, ... }: {
    channelName = "nixos-steve";
    # Relative to flake.nix
    modules = [
      nixos-hardware.nixosModules.common-pc
      nixos-hardware.nixosModules.common-cpu-intel
      # nixos-hardware.nixosModules.common-gpu-nvidia
      nixos-hardware.nixosModules.common-gpu-amd
      nur-alexnortung-steve.nixosModules.autorandr
      ./configuration.nix
    ];
  };
}
