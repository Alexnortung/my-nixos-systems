# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = builtins.readFile ./config/init.vim;
      packages.nix = with pkgs.vimPlugins; {
        start = [
          vim-surround # Shortcuts for setting () {} etc.
          coc-nvim coc-git coc-highlight coc-python coc-rls coc-vetur coc-vimtex coc-yaml coc-html coc-json # auto completion
          vim-nix # nix highlight
          vim-javascript # javascript highlight
          vim-yaml # yaml highlight
          vimtex # latex stuff
          fzf-vim # fuzzy finder through vim
          nerdtree # file structure inside nvim
          rainbow # Color parenthesis
        ];
        opt = [];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    nodejs
  ];
  #environment.systemPackages = with pkgs; [
  #  (neovim.override {
  #    vimAlias = true;
  #    configure = {
  #      customRC = builtins.readFile ./config/init.vim;
  #      packages.myPlugins = with pkgs.vimPlugins; {
  #        start = [
  #          vim-surround # Shortcuts for setting () {} etc.
  #          coc-nvim coc-git coc-highlight coc-python coc-rls coc-vetur coc-vimtex coc-yaml coc-html coc-json # auto completion
  #          vim-nix # nix highlight
  #          vimtex # latex stuff
  #          fzf-vim # fuzzy finder through vim
  #          nerdtree # file structure inside nvim
  #          rainbow # Color parenthesis
  #        ];
  #        opt = [];
  #      };
  #    };
  #  })
  #];
}
