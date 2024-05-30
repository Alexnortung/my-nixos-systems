let
  system = "aarch64-linux";
in
{
  host = inputs@{ nixos-hardware, ... }: {
    channelName = "nixos-stable";
    system = system;
    # Relative to flake.nix
    modules = [
      nixos-hardware.nixosModules.raspberry-pi-4
      ./configuration.nix
    ];
  };

  # deploy-rs node
  node = inputs@{ self, deploy-rs, ... }: {
    hostname = "192.168.3.11";
    profiles.system = {
      path =
        deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.chest;
      sshUser = "nixos";
      user = "root";
    };
  };
}
