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
    ref = "refs/heads/nixos-21.11";
    rev = "386234e2a61e1e8acf94dfa3a3d3ca19a6776efb";
  };
  nixos-version = import "${nixos-version-fetched}" { 
    name = "nvim-version";
    inherit (config.nixpkgs) config overlays localSystem crossSystem;
  };
  my-pkgs = import (unstable.fetchFromGitHub {
    owner = "alexnortung";
    repo = "nixpkgs";
    rev = "21972788106d85a26ff9c51b2f18eb8b23e2ee0c";
    sha256 = "zHxkRaCvK83m2y8Zkfggs8PvBsZyK4JsZORvomEnEU4=";
  }) {};
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
      plug.plugins = [
      ];
      packages.nix = with nixos-version.vimPlugins; {
        start = [
          # Snippets
          vim-snippets
          ultisnips
          my-pkgs.vimPlugins.vim-svelte
          my-pkgs.vimPlugins.coc-svelte
          my-pkgs.vimPlugins.coc-tailwindcss
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
          #coc-svelte
          coc-json # auto completion
          coc-css
          #coc-tailwindcss
          coc-emmet
          coc-tsserver
          coc-eslint
          coc-snippets
          coc-clangd
          #coc-phpls
          emmet-vim
          #vim-svelte
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

