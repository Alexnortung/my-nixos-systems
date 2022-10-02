{
  host = input@{ nixos-hardware, ... }: let
    system = "x86_64-linux";
  in {
    inherit system;
    extraArgs = { inherit system; };
    channelName = "nixos-stable";
    # Relative to flake.nix
    modules = [
      nixos-hardware.nixosModules.dell-latitude-3480
      ./configuration.nix
    ];
  };
}
