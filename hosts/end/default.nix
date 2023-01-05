{
  host = inputs@{ ... }: {
    channelName = "nixos-stable";
    # Relative to flake.nix
    modules = [
      # inputs.mail-server.nixosModule
      ./configuration.nix
    ];
  };
  # deploy-rs node
  node = inputs@{ self, deploy-rs, ... }: {
    hostname = "86.48.0.131";
    profiles.system = {
      path =
        deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.end;
      sshUser = "root";
      user = "root";
    };
  };
}
