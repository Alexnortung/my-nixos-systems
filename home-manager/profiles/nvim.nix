{ inputs, pkgs, ... }:

{
  # Requires the following for home manager
  # modules = [
  #   inputs.nixvim.homeManagerModules.nixvim
  # ];

  programs.nixvim = {
    enable = true;

    maps = {
      normal."<leader>p" = "<cmd>Telescope find_files<CR>";

      # Better windom navigation
      normal."<C-h>" = "<C-w>h";
      normal."<C-j>" = "<C-w>j";
      normal."<C-k>" = "<C-w>k";
      normal."<C-l>" = "<C-w>l";

      # Make sure leader does not do it's default action
      normal."<Space>" = "<Nop>";

      # Move between buffers easily
      normal."<A-l>" = ":bnext<CR>";
      normal."<A-h>" = ":bprevious<CR>";

      # Indent, stay in visual mode
      visual."<" = "<gv";
      visual.">" = ">gv";

      # Move text under cursor up and down
      visual."<A-j>" = ":m .+1<CR>==";
      visual."<A-k>" = ":m .-2<CR>==";

      # When pasting in visual mode, do not yank the replaces text
      visual."p" = "_dP";

      # Nvim tree
      normal."<leader>nn" = ":NvimTreeToggle<CR>";
      normal."<leader>nf" = ":NvimTreeFindFile<CR>";
    };

    options = {
      number = true; # sets numbers in the side
      relativenumber = true; # makes side numbers relative to the cursor
      expandtab = true; # nicer default tabs
      clipboard = "unnamedplus"; # use system clipboard
      mouse = "a"; # make neovim usable with mouse
      smartcase = true; # "smart" search
      splitbelow = true;
      splitright = true;
      shiftwidth = 4;
      tabstop = 4;
      cursorline = true;
      smartindent = 1;
    };

    globals = {
      mapleader = " ";
    };

    plugins = {
      lsp = {
        enable = true;
        servers = {
          clangd.enable = true;
          rnix-lsp.enable = true;
          pyright.enable = true;
          rust-analyzer.enable = true;
        };
      };

      telescope = {
        enable = true;
      };

      nvim-tree = {
        enable = true;

        git = {
          enable = "true";
          ignore = true;
          timeout = 500;
        };

        view = {
          side = "right";
        };

        trash = {
          cmd = "trash";
          requireConfirm = true;
        };
      };

      surround = {
        enable = true;
      };

      bufferline = {
        enable = true;
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
        indent = true;
        ensureInstalled = "all";
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      nvim-cmp
      cmp-path
      cmp-buffer
      cmp-cmdline
      cmp_luasnip
      luasnip
      friendly-snippets
      vim-sleuth # detects indentation
    ];

    # plugins.lightline.enable = true;
    colorschemes.nord = {
      enable = true;
      borders = true;
      contrast = true;
    };

    extraConfigLua = builtins.readFile ./nvim/main.lua;
  };
}
