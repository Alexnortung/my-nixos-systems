{
  host =
    inputs@{ nixos-hardware, ... }:
    {
      channelName = "nixos-paper";
      # Relative to flake.nix
      modules = [
        nixos-hardware.nixosModules.hp-zbook-x-g1i
        ./configuration.nix
      ];
    };
}
