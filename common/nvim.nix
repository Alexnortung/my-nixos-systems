# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, lib, ... }:

let
  # Unstable
  unstable = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs/";
    rev = "e6df26a654b7fdd59a068c57001eab5736b1363c";
  }) { };
  uvi = unstable.vimPlugins;
  nixos-version-fetched = builtins.fetchGit {
    name = "nixos-neovim-module";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/tags/22.05-pre";
    rev = "e96c668072d7c98ddf2062f6d2b37f84909a572b";
  };
  #nixos-version = import "${nixos-version-fetched}" { 
  #  inherit (config.nixpkgs) config overlays localSystem crossSystem;
  #};
in
{
  disabledModules = [
    "programs/neovim.nix"
  ];
  imports = [
    "${nixos-version-fetched}/nixos/modules/programs/neovim.nix"
  ];
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
          # COC
          coc-nvim
          coc-git
          coc-highlight
          coc-python
          coc-rust-analyzer
          coc-vetur
          coc-vimtex
          coc-yaml
          coc-html
          coc-json # auto completion
          coc-css
          coc-emmet
          coc-tsserver
          coc-eslint
          coc-snippets
          coc-clangd
          #coc-phpls
          vim-nix # nix highlight
          vim-javascript # javascript highlight
          vim-yaml # yaml highlight
          vimtex # latex stuff
          #fzf-vim # fuzzy finder through vim
          telescope-nvim # fzf improved, fuzzy finder
          #nerdtree # file structure inside nvim
          rainbow # Color parenthesis
          uvi.futhark-vim # Futhark programming language
          pear-tree # smart closing brackets
          uvi.jsonc-vim # can show correct syntax for jsonc files
          vim-twig # syntax highlight for twig
          nord-nvim # Nord theme for vim
          #nord-vim # Nord theme for vim
          uvi.indent-blankline-nvim # Shows indentation with small lines
          vim-sleuth # Detects indentation
          (uvi.nvim-treesitter.withPlugins (plugins: unstable.tree-sitter.allGrammars)) # better syntax highlight
          uvi.nvim-web-devicons
          uvi.nvim-tree-lua
        ];
        opt = [
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    #nodejs
    ripgrep # used by telescope
    unstable.clang-tools
    #llvm
    clang_12
    rust-analyzer
  ];
}

