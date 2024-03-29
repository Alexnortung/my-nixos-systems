{
  description = "Alexnortung's system configurations and server configurations";

  inputs = {
    utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus/";
    # nixos-dev = {
    #   url = "path:/home/alexander/source/nixpkgs";
    # };
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-alexnortung.url = "github:alexnortung/nixpkgs/s3fs-module";
    s3fs-fuse = {
      url = "github:alexnortung/nixpkgs/s3fs-module";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nollevim = {
      url = "github:Alexnortung/nollevim";
    };

    vim-extra-plugins.url = "github:m15a/nixpkgs-vim-extra-plugins";

    agenix = {
      url = "github:ryantm/agenix/0.13.0"; # for encrypted secrets. such as wireguard keys
      # inputs.nixpkgs.follows = "nixos-stable";
      # inputs.home-manager.follows = "home-manager";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    devenv = {
      url = "github:cachix/devenv/v0.6.3";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    # nixvim = {
    #   url = "github:pta2002/nixvim";
    #   # url = "github:Alexnortung/nixvim/alexnortung-main";
    #   # url = "path:/home/alexander/source/nixvim/";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    minecraft-servers = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    mail-server = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-23_05.follows = "nixos-stable";
    };

    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    oak-configs = {
      url = "git+ssh://git@github.com/Oak-Digital/oak-nix-configs";
    };

    #local-nixpkgs.url = "path:/home/alexander/source/nixpkgs";
  }
    #// ((import ./hosts).inputs)
  ;

  outputs =
    inputs@{ self
    , utils-plus
    , vim-extra-plugins
    , fenix
      # , neovim
    , agenix
      # , nixvim
    , minecraft-servers
    , nix-on-droid
    , hosts
    , ...
    }:
    utils-plus.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        fenix.overlay
        vim-extra-plugins.overlays.default
        minecraft-servers.overlay
        # neovim.overlay
        # (import ./overlays/default-unstable.nix inputs.nixos-unstable)
        #agenix.overlay
      ];

      homeConfigurations = (import ./home-manager { inherit inputs; }).configs;

      channelsConfig = {
        # Default channel configuration
        # allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) (import ./config/allowed-unfree-packages.nix);
        allowUnfreePredicate = (pkg: true);
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-24.8.6"
        ];
      };

      channels.nixos-stable.overlaysBuilder = channels: [
        # (import ./overlays/default-unstable.nix channels.nixpkgs-unstable)
        (final: prev: {
          unstable = channels.nixpkgs-unstable;
        })
        # (import ./overlays/unstable.nix inputs)
        # (final: prev: { inherit (channels.nixpkgs-unstable) session-desktop krita; })
      ];

      hostDefaults = {
        extraArgs = {
          # add utils and inputs to each host.
          inherit utils-plus inputs;
        };
        modules = [
          agenix.nixosModules.age
          # nixvim.nixosModules.nixvim
          inputs.mail-server.nixosModule
          # import ./modules # My extra modules
          hosts.nixosModule
          "${inputs.s3fs-fuse}/nixos/modules/services/network-filesystems/s3fs-fuse.nix"

          minecraft-servers.nixosModules.minecraft-servers

          ./cachix.nix
        ];
      };
      hosts = (import ./hosts/default.nix).hosts inputs;

      # deploy-rs definitions
      deploy = {
        nodes = (import ./hosts/default.nix).nodes inputs;
      };
      # nixOnDroidConfigurations = {
      #   bundle = nix-on-droid.lib.nixOnDroidConfiguration {
      #     config = ./hosts/droid-devices/bundle/configuration.nix;
      #     system = "aarch64-linux";
      #     extraSpecialArgs = {
      #       inherit inputs;
      #     };
      #     pkgs = import nixpkgs {
      #       overlays = [
      #         fenix.overlay
      #         vim-extra-plugins.overlay
      #         neovim.overlay
      #       ];
      #     };
      #     extraModules = [
      #       #(import ./modules/system-packages-to-packages.nix)
      #     ];
      #   };
      # };
    };
}
