# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, lib, ... }:

let
  # Unstable
  unstable = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    rev = "931ab058daa7e4cd539533963f95e2bb0dbd41e6";
  }) { };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    package = pkgs.neovim-unwrapped;
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
          unstable.vimPlugins.futhark-vim # Futhark programming language
          pear-tree # smart closing brackets
          unstable.vimPlugins.jsonc-vim # can show correct syntax for jsonc files
        ];
        opt = [];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    #nodejs
  ];
}
