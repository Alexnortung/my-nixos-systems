{ inputs, ... }:

let
  system = "x86_64-linux";
  # pkgs = inputs.nixos-stable.legacyPackages.${system};
  pkgs = import inputs.nixos-stable {
    inherit system;
    overlays = [
      inputs.hyprpanel.overlay
    ];
    extraSpecialArgs = {
      inherit system;
      inherit inputs;
    };

    permittedInsecurePackages = [
      "beekeeper-studio-5.2.12"
    ];
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    inputs.stylix.homeModules.stylix
    ../../../config/stylix.nix
    ../../profiles/nvim.nix
    # ../../profiles/eww
    ./home.nix
    ../../profiles/direnv.nix
    ../../profiles/git.nix
    ../../profiles/hyprland.nix
    ../../profiles/polybar.nix
    ../../profiles/rofi.nix
    ../../profiles/gcalcli-remind.nix
    inputs.oak-configs.homeManagerModules.ssh
  ];

  extraSpecialArgs = {
    inherit system inputs;
  };
}
