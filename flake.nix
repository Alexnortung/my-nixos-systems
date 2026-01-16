{
  description = "Alexnortung's system configurations and server configurations";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://deploy-rs.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "deploy-rs.cachix.org-1:xfNobmiwF/vzvK1gpfediPwpdIP0rpDV2rYqx40zdSI="
    ];
  };

  inputs = {
    utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.5.1";
    # nixos-dev = {
    #   url = "path:/home/alexander/source/nixpkgs";
    # };
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-enderman.url = "github:NixOS/nixpkgs/nixos-25.11";
    # nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-alexnortung.url = "github:alexnortung/nixpkgs/s3fs-module";
    # s3fs-fuse = {
    #   url = "github:alexnortung/nixpkgs/s3fs-module";
    # };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable-master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprpanel.inputs.nixpkgs.follows = "nixos-stable";

    stylix.url = "github:danth/stylix/release-25.05";

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
      # inputs.nixpkgs.follows = "nixos-stable";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    devenv = {
      url = "github:cachix/devenv/v1.6";
      # inputs.nixpkgs.follows = "nixos-stable";
    };

    # block-busters = {
    #   url = "github:Alexnortung/block-busters";
    #   # url = "path:/home/alexander/source/block-busters";
    # };

    # nixvim = {
    #   url = "github:pta2002/nixvim";
    #   # url = "github:Alexnortung/nixvim/alexnortung-main";
    #   # url = "path:/home/alexander/source/nixvim/";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    minecraft-servers = {
      url = "github:Infinidoge/nix-minecraft";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    mail-server = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";

    oak-configs = {
      url = "git+ssh://git@github.com/Oak-Digital/oak-nix-configs";
    };

    #local-nixpkgs.url = "path:/home/alexander/source/nixpkgs";
  }
  #// ((import ./hosts).inputs)
  ;

  outputs =
    inputs@{
      self,
      utils-plus,
      vim-extra-plugins,
      fenix,
      # , neovim
      agenix,
      # , nixvim
      minecraft-servers,
      nix-on-droid,
      hosts,
      cachix-deploy-flake,
      stylix,
      ...
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
          "dotnet-sdk-6.0.428"
          "aspnetcore-runtime-6.0.36"
          "beekeeper-studio-5.1.5"
          "beekeeper-studio-5.2.12"
        ];
      };

      channels.nixos-stable.overlaysBuilder = channels: [
        # (import ./overlays/default-unstable.nix channels.nixpkgs-unstable)
        (final: prev: { unstable = channels.nixpkgs-unstable; })
        # (import ./overlays/unstable.nix inputs)
        # (final: prev: { inherit (channels.nixpkgs-unstable) session-desktop krita; })
      ];

      hostDefaults = {
        extraArgs = {
          # add utils and inputs to each host.
          inherit utils-plus inputs;
        };
        modules = [
          stylix.nixosModules.stylix
          agenix.nixosModules.age
          # nixvim.nixosModules.nixvim
          inputs.mail-server.nixosModule
          # import ./modules # My extra modules
          hosts.nixosModule
          # "${inputs.s3fs-fuse}/nixos/modules/services/network-filesystems/s3fs-fuse.nix"

          minecraft-servers.nixosModules.minecraft-servers
          # inputs.block-busters.nixosModules.discord-bot

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

      outputsBuilder =
        channels:
        let
          pkgs = channels.nixpkgs-unstable;
          cachix-deploy-lib = cachix-deploy-flake.lib channels.nixpkgs-unstable;
        in
        {
          packages = {
            # cachix-deploy-spec = cachix-deploy-lib.spec {
            #   agents = (import ./hosts/default.nix).cachixDeployAgents inputs;
            # };

            minecraft-whitelist-add = pkgs.writeShellScriptBin "minecraft-whitelist-add" ''
              #!${pkgs.stdenv.shell}
              echo "Adding" "$1"
              cat ./hosts/enderman/minecraft-whitelist.json | \
                jq ".\"$1\" = \"$2\"" > ./hosts/enderman/minecraft-whitelist.tmp.json
              mv ./hosts/enderman/minecraft-whitelist.tmp.json ./hosts/enderman/minecraft-whitelist.json
            '';
          };
        };
    };
}
