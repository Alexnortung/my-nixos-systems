{
  host = input@{ ... }: {
    channelName = "nixos-stable";
    # Relative to flake.nix
    modules = [
      ./configuration.nix
    ];
  };
  # deploy-rs node
  node = inputs@{ self, deploy-rs, ... }: {
    hostname = "10.100.0.2";
    profiles.system = {
      path =
        deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.enderman;
      sshUser = "root";
      user = "root";
    };
  };
}
