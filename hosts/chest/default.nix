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
      user = "nixos";
    };
  };

  cachixDeployAgent = inputs@{ self, cachix-deploy-flake, nixos-stable, nixos-hardware, ... }:
    let
      pkgs = import nixos-stable { inherit system; };
      cachix-deploy-lib = cachix-deploy-flake.lib pkgs;
    in
    cachix-deploy-lib.nixos {
      imports = [
        nixos-hardware.nixosModules.raspberry-pi-4
        ./configuration.nix
      ];
    };
}
