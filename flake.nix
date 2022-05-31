{
  description = "Alexnortung's system configurations and server configurations";

  inputs = {
    utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    vim-extra-plugins.url = "github:Alexnortung/nixpkgs-vim-extra-plugins";

    agenix.url = "github:ryantm/agenix"; # for encrypted secrets. such as wireguard keys
    deploy-rs.url = "github:serokell/deploy-rs";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify.url = "github:PhilTaken/spicetify-nix";

    # import hosts
    nixos-boat.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable-boat.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur-alexnortung-boat.url = "github:Alexnortung/nur-alexnortung";

    nixos-spider.url = "github:NixOS/nixpkgs/release-21.11";
    nixpkgs-unstable-spider.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur-alexnortung-spider.url = "github:Alexnortung/nur-alexnortung";

    nixos-steve.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable-steve.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur-alexnortung-steve.url = "github:Alexnortung/nur-alexnortung";

    nixos-enderman.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable-enderman.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur-alexnortung-enderman.url = "github:Alexnortung/nur-alexnortung";

    nix-on-droid.url = "github:t184256/nix-on-droid";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";

    # pre master inputs
    emojipick.url = "github:NixOS/nixpkgs/2325a754e19e40b227b50323acfedca41836fbf9";
    spicetified-spotify.url = "github:NixOS/nixpkgs/4ba5b6e107e02abe924b4a04894203705f741a00";

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
  , nix-on-droid
  , ... }:
    utils-plus.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        fenix.overlay
        vim-extra-plugins.overlay
        neovim.overlay
        #agenix.overlay
      ];

      channelsConfig = {
        # Default channel configuration
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) (import ./config/allowed-unfree-packages.nix);
      };

      channels = ((import ./hosts/default.nix).channels inputs) // {
      };

      hostDefaults = {
        extraArgs = {
          # add utils and inputs to each host.
          inherit utils-plus inputs;
          modules = [
            agenix.nixosModules.age
            import ./modules # My extra modules
          ];
        };
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
