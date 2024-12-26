{ inputs, ... }:

let
  system = "x86_64-linux";
  pkgs = inputs.nixos-stable.legacyPackages.${system};
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    inputs.stylix.homeManagerModules.stylix
    ../../../config/stylix.nix
    ../../profiles/nvim.nix
    # ../../profiles/eww
    ./home.nix
    ../../profiles/direnv.nix
    ../../profiles/git.nix
    ../../profiles/hyprland.nix
    ../../profiles/polybar.nix
    ../../profiles/rofi.nix
    inputs.oak-configs.homeManagerModules.ssh
  ];

  extraSpecialArgs = {
    inherit system inputs;
  };
}
