{
  description = "Alexnortung's system configurations and server configurations";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    # Pull request inputs - One commit is fine since there is only one important commit.
    #nixpkgs-emojipick.url = "github:nixOS/nixpkgs/2325a754e19e40b227b50323acfedca41836fbf9";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # import hosts
    nixos-boat.url = "github:NixOS/nixpkgs/386234e2a61e1e8acf94dfa3a3d3ca19a6776efb";
    nixpkgs-unstable-boat.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware-boat.url = "github:NixOS/nixos-hardware";
    nur-alexnortung-boat.url = "github:Alexnortung/nur-alexnortung";
  }
  #// ((import ./hosts).inputs)
  ;

  outputs = inputs@{ self, utils, nixpkgs, ... }:
    utils.lib.mkFlake {
      inherit self inputs;

      channelsConfig = {
        # Default channel configuration
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) (import ./config/allowed-unfree-packages.nix);
      };

      channels = (import ./hosts/default.nix).channels;

      hostDefaults = {
        extraArgs = {
          # add utils and inputs to each host.
          inherit utils inputs;
        };
      };
      hosts = (import ./hosts/default.nix).hosts inputs;
    };
}
