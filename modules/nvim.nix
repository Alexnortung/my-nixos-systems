# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, lib, ... }:

{
  imports = [
    ../modules/ruststable.nix
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    package = pkgs.neovim;
    configure = {
      customRC = builtins.readFile ../config/init.vim;
      packages.nix = with pkgs.vimPlugins; with pkgs.vimExtraPlugins; {
        start = [
          # Snippets
          vim-snippets
          ultisnips
          vim-surround # Shortcuts for setting () {} etc.
          # LSP
          nvim-lspconfig
          lsp_signature-nvim
          lspsaga-nvim
          # cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          nvim-cmp
          cmp-nvim-ultisnips
          # COC
          #coc-yaml
          #coc-html
          #coc-css
          #coc-eslint
          #coc-clangd
          emmet-vim
          editorconfig-vim
          # Syntax highlight
          vim-svelte-plugin
          tailwindcss-colors-nvim
          vim-nix # nix highlight
          vim-javascript # javascript highlight
          typescript-vim
          vim-yaml # yaml highlight
          vimtex # latex stuff
          #fzf-vim # fuzzy finder through vim
          telescope-nvim # fzf improved, fuzzy finder
          #nerdtree # file structure inside nvim
          rainbow # Color parenthesis
          futhark-vim # Futhark programming language
          pear-tree # smart closing brackets
          jsonc-vim # can show correct syntax for jsonc files
          vim-twig # syntax highlight for twig
          nord-nvim # Nord theme for vim
          #nord-vim # Nord theme for vim
          #indent-blankline-nvim # Shows indentation with small lines
          vim-sleuth # Detects indentation
          #(uvi.nvim-treesitter.withPlugins (plugins: unstable.tree-sitter.allGrammars)) # better syntax highlight
          nvim-web-devicons
          nvim-tree-lua
          bufferline-nvim # Good looking buffer line
          dashboard-nvim
          tcomment_vim
        ];
        opt = [
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    #nodejs
    ripgrep # used by telescope
    clang-tools
    #llvm
    clang_12
    rust-analyzer

    # LSP packages
    nodePackages.pyright
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.svelte-language-server
    nodePackages."@tailwindcss/language-server"
    #nodePackages.emmet-ls
    rnix-lsp
  ];
}

