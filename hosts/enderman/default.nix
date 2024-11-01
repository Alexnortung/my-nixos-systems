{
  host = inputs@{ nixos-hardware, ... }: {
    channelName = "nixos-stable";
    # Relative to flake.nix
    modules = [
      ./configuration.nix
      # inputs.nixos-dev
      nixos-hardware.nixosModules.common-cpu-intel
      # inputs.block-busters.nixosModules.discord-bot
    ];
  };
  # deploy-rs node
  node = inputs@{ self, deploy-rs, ... }: {
    hostname = "10.101.0.2";
    profiles.system = {
      path =
        deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.enderman;
      sshUser = "root";
      user = "root";
    };
  };
}
