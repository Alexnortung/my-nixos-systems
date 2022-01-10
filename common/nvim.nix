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
    ref = "refs/heads/nixos-21.11-small";
    rev = "79c7b6a353e22f0eec342dead0bc69fb7ce846db";
  };
  nixos-version = import "${nixos-version-fetched}" { 
    name = "nvim-version";
    inherit (config.nixpkgs) config overlays localSystem crossSystem;
  };
  coc-tailwindcss = nixos-version.vimUtils.buildVimPlugin {
    name = "coc-tailwindcss";
    src = pkgs.fetchFromGitHub {
      owner = "iamcco";
      repo = "coc-tailwindcss";
      rev = "5f41aa1feb36e39b95ccd83be6a37ee8c475f9fb";
      sha256 = "189abl36aj862m5nz8jjdgdfc4s6xbag030hi9m13yd6fbg99f85";
    };
  };
  vim-svelte = nixos-version.vimUtils.buildVimPlugin {
    name = "vim-svelte";
    src = pkgs.fetchFromGitHub {
      owner = "evanleck";
      repo = "vim-svelte";
      rev = "5f88e5a0fe7dcece0008dae3453edbd99153a042";
      sha256 = "1467b0bfnn8scgni405xfsj3zk8vfgj44mnm1lvr9ir696r2gmp0";
    };
  };
  coc-svelte = nixos-version.vimUtils.buildVimPlugin {
    name = "coc-svelte";
    src = pkgs.fetchFromGitHub {
      owner = "coc-extensions";
      repo = "coc-svelte";
      rev = "5743da35da727ce8bf8a8b9733ee7ff61d476b4e";
      sha256 = "1467b0bfnn8scgni405xfsj3zk8vfgj44mnm1lvr9ir696r2gmp0";
    };
  };
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
          vim-svelte
          coc-svelte
          coc-tailwindcss
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

