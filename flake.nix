{
  description = "Alexnortung's system configurations and server configurations";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    # Pull request inputs - One commit is fine since there is only one important commit.
    #nixpkgs-emojipick.url = "github:nixOS/nixpkgs/2325a754e19e40b227b50323acfedca41836fbf9";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    vim-extra-plugins.url = "github:m15a/nixpkgs-vim-extra-plugins/7d8682f3bd150696f0fd45b1518689d76abfbb63";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:neovim/neovim/?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # import hosts
    nixos-boat.url = "github:NixOS/nixpkgs/386234e2a61e1e8acf94dfa3a3d3ca19a6776efb";
    nixpkgs-unstable-boat.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware-boat.url = "github:NixOS/nixos-hardware";
    nur-alexnortung-boat.url = "github:Alexnortung/nur-alexnortung";

    # pre master inputs
    emojipick.url = "github:NixOS/nixpkgs/2325a754e19e40b227b50323acfedca41836fbf9";
  }
  #// ((import ./hosts).inputs)
  ;

  outputs = inputs@{
    self
  , utils
  , nixpkgs
  , vim-extra-plugins
  , fenix
  , neovim
  , ... }:
    utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        fenix.overlay
        vim-extra-plugins.overlay
        neovim.overlay
      ];

      channelsConfig = {
        # Default channel configuration
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) (import ./config/allowed-unfree-packages.nix);
      };

      channels = (import ./hosts/default.nix).channels // {
      };

      hostDefaults = {
        extraArgs = {
          # add utils and inputs to each host.
          inherit utils inputs;
        };
      };
      hosts = (import ./hosts/default.nix).hosts inputs;
    };
}
