{
  description = "Alexnortung's system configurations and server configurations";

  inputs = {
    utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus/";
    # nixos-dev = {
    #   url = "path:/home/alexander/source/nixpkgs";
    # };
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    nollevim = {
      url = "github:Alexnortung/nollevim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    vim-extra-plugins.url = "github:m15a/nixpkgs-vim-extra-plugins";

    agenix = {
      url = "github:ryantm/agenix"; # for encrypted secrets. such as wireguard keys
      inputs.nixpkgs.follows = "nixos-stable";
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
      url = "github:cachix/devenv/v0.5";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    # nixvim = {
    #   url = "github:pta2002/nixvim";
    #   # url = "github:Alexnortung/nixvim/alexnortung-main";
    #   # url = "path:/home/alexander/source/nixvim/";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    minecraft-servers = {
      url = "github:jyooru/nix-minecraft-servers";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    mail-server = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-22_05.follows = "nixos-stable";
    };

    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixos-stable";
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
    , nix-on-droid
    , hosts
    , ...
    }:
    utils-plus.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        fenix.overlay
        vim-extra-plugins.overlays.default
        # neovim.overlay
        # (import ./overlays/default-unstable.nix inputs.nixos-unstable)
        #agenix.overlay
      ];

      homeConfigurations = (import ./home-manager { inherit inputs; }).configs;

      channelsConfig = {
        # Default channel configuration
        # allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) (import ./config/allowed-unfree-packages.nix);
        allowUnfree = true;
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
