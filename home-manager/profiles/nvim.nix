{
  imports = [
    ../../profiles/nvim/default.nix
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  systemd.user.sessionVariables = {
    EDITOR = "nvim";
  };
}
