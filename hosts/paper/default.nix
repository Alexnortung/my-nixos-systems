{
  host =
    inputs@{ nixos-hardware, ... }:
    {
      channelName = "nixos-paper";
      # Relative to flake.nix
      modules = [
        ./configuration.nix
      ];
    };
}
