{
  description = "Alexnortung's system configurations and server configurations";

  inputs = {
    utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    # nixos-stable.url = "path:/home/alexander/source/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    vim-extra-plugins.url = "github:m15a/nixpkgs-vim-extra-plugins";

    agenix.url = "github:ryantm/agenix"; # for encrypted secrets. such as wireguard keys
    deploy-rs.url = "github:serokell/deploy-rs";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    nixvim = {
      url = "github:pta2002/nixvim";
      # url = "github:Alexnortung/nixvim/test-branch";
      # url = "path:/home/alexander/source/nixvim/";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    # import hosts
    nixos-boat.url = "github:NixOS/nixpkgs/nixos-22.05";
    # nixos-boat.url = "path:/home/alexander/source/nixpkgs";
    nixpkgs-unstable-boat.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur-alexnortung-boat.url = "github:Alexnortung/nur-alexnortung";

    nixos-spider.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable-spider.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur-alexnortung-spider.url = "github:Alexnortung/nur-alexnortung";

    nixos-steve.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable-steve.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur-alexnortung-steve.url = "github:Alexnortung/nur-alexnortung";

    nixos-enderman.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable-enderman.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur-alexnortung-enderman.url = "github:Alexnortung/nur-alexnortung";

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    #local-nixpkgs.url = "path:/home/alexander/source/nixpkgs";
  }
  #// ((import ./hosts).inputs)
  ;

  outputs = inputs@{
    self
  , utils-plus
  , nixpkgs
  , vim-extra-plugins
  , fenix
  , neovim
  , agenix
  , nixvim
  , nix-on-droid
  , ... }:
    utils-plus.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        fenix.overlay
        vim-extra-plugins.overlays.default
        neovim.overlay
        #agenix.overlay
      ];

      homeConfigurations =(import ./home-manager { inherit inputs; }).configs;

      channelsConfig = {
        # Default channel configuration
        # allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) (import ./config/allowed-unfree-packages.nix);
        allowUnfree = true;
      };

      channels = ((import ./hosts/default.nix).channels inputs) // {
      };

      hostDefaults = {
        extraArgs = {
          # add utils and inputs to each host.
          inherit utils-plus inputs;
        };
        modules = [
          agenix.nixosModules.age
          nixvim.nixosModules.nixvim
          # import ./modules # My extra modules
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
