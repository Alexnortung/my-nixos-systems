{ pkgs, config, ... }:

{
  home-manager.config =
    { inputs, pkgs, lib, ... }:
    {
      # Read the changelog before changing this value
      home.stateVersion = "21.11";
  
      # Use the same overlays as the system packages
      nixpkgs = { inherit (config.nixpkgs) overlays; };

      # insert home-manager config
      
      home.packages = with pkgs; [
        git
        vim
        zip unzip
        diffutils
        findutils
        #utillinux
        #tzdata
        hostname
        man
        gnugrep
        #gnupg
        #gnused
        #gnutar
        #bzip2
        gzip
        #xz
      ];
      programs.git = {
        enable = true;
        userEmail = "alex_nortung@live.dk";
        userName = "Alexander Nortung";
      };
      programs.neovim = {
        enable = true;
        withNodeJs = true;
        extraConfig = builtins.readFile ../../../config/init.vim;
        plugins = with pkgs.vimPlugins; with pkgs.vimExtraPlugins; [
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
          colorizer # gives hex and rgb values a color.
        ];
        extraPackages = with pkgs; [
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
          nodePackages.vls
          #nodePackages.emmet-ls
          rnix-lsp
        ];
      };
    };
  # If you want the same pkgs instance to be used for nix-on-droid and home-manager
  home-manager.useGlobalPkgs = true;
}
