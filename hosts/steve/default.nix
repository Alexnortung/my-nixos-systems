{
  host = input@{ nixos-hardware, ... }: {
    channelName = "nixos-stable";
    # Relative to flake.nix
    modules = [
      nixos-hardware.nixosModules.common-pc
      nixos-hardware.nixosModules.common-cpu-intel
      # nixos-hardware.nixosModules.common-gpu-nvidia
      nixos-hardware.nixosModules.common-gpu-amd
      ./configuration.nix
    ];
  };
}
