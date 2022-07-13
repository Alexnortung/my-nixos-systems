{ inputs, pkgs, ... }:

{
  # Requires the following for home manager
  # modules = [
  #   inputs.nixvim.homeManagerModules.nixvim
  # ];

  programs.nixvim = {
    enable = true;

    maps = {
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

      # LSP stuff
      normal."gD" = "<cmd>lua vim.lsp.buf.declaration()<CR>";
      normal."dg" = "<cmd>lua vim.lsp.buf.definition()<CR>";
      normal."K" = "<cmd>lua vim.lsp.buf.hover()<CR>";
      normal."gi" = "<cmd>lua vim.lsp.buf.implementation()<CR>";
      # normal."<C-k>" = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
      normal."gr" = "<cmd>lua vim.lsp.buf.references()<CR>";
      normal."<leader>ca" = "<cmd>lua vim.lsp.buf.code_action()<CR>";

      # Telescope
      normal."<leader>p" = "<cmd>Telescope find_files<CR>";
      normal."<leader>ff" = "<cmd>Telescope find_files<CR>";
      normal."<leader>fl" = "<cmd>Telescope live_grep<CR>";
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

      rainbow_active = 1;
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

      nvim-autopairs = {
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
      cmp-nvim-lsp
      cmp_luasnip
      luasnip
      friendly-snippets
      vim-sleuth # detects indentation
      rainbow
      futhark-vim # Futhark programming language
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
