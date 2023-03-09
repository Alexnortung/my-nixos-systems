{inputs, system, ...}: {
  # imports = [
  #   ../../profiles/nvim/default.nix
  # ];
  home.packages = [
    inputs.nollevim.packages.${system}.default
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  systemd.user.sessionVariables = {
    EDITOR = "nvim";
  };
}
