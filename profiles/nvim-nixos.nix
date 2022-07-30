{
  imports = [
    ./nvim
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
