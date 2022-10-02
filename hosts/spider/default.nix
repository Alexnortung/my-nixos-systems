{
  host = inputs@{ nixos-hardware, ... }: {
    channelName = "nixos-stable";
    # Relative to flake.nix
    modules = [
      # "${inputs.nixpkgs-alexnortung}/nixos/modules/services/network-filesystems/s3fs-fuse.nix"
      nixos-hardware.nixosModules.lenovo-thinkpad-x13
      ./configuration.nix
    ];
  };
}
