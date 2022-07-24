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
      number = true;                # sets numbers in the side
      relativenumber = true;        # makes side numbers relative to the cursor
      expandtab = true;             # nicer default tabs
      clipboard = "unnamedplus";    # use system clipboard
      mouse = "a";                  # make neovim usable with mouse
      smartcase = true;             # "smart" search
      ignorecase = true;
      splitbelow = true;
      splitright = true;
      shiftwidth = 4;
      tabstop = 4;
      cursorline = true;
      smartindent = 1;
      scrolloff = 4;                # keeps lines above and below
    };

    globals = {
      mapleader = " ";

      rainbow_active = 1;

      kind_icons = {
        Text = "";
        Method = "m";
        Function = "";
        Constructor = "";
        Field = "";
        Variable = "";
        Class = "";
        Interface = "";
        Module = "";
        Property = "";
        Unit = "";
        Value = "";
        Enum = "";
        Keyword = "";
        Snippet = "";
        Color = "";
        File = "";
        Reference = "";
        Folder = "";
        EnumMember = "";
        Constant = "";
        Struct = "";
        Event = "";
        Operator = "";
        TypeParameter = "";
      };
    };

    plugins = {
      lsp = {
        enable = true;
        servers = {
          clangd.enable = true;
          rnix-lsp.enable = true;
          pyright.enable = true;
          rust-analyzer.enable = true;
          html.enable = true;
          cssls.enable = true;
          jsonls.enable = true;
          eslint.enable = true;
          gdscript.enable = true;
        };
      };

      telescope = {
        enable = true;
      };

      nvim-tree = {
        enable = true;

        git = {
          enable = true;
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

      comment-nvim = {
        enable = true;
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

      nvim-cmp = {
        enable = true;
        preselect = "None";
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        mappingPresets = [ "insert" ];
        mapping = {
          "<C-b>" = ''cmp.mapping.scroll_docs(-4)'';
          "<C-f>" = ''cmp.mapping.scroll_docs(4)'';
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif check_backspace() then
                  fallback()
                else
                  fallback()
                end
              end
            '';
          };
          "<S-Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end
            '';
          };
        };

        formatting = {
          fields = [
            "kind"
            "abbr"
            "menu"
          ];
          format = ''
            function(entry, vim_item)
              -- Kind icons
              vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
              -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
              vim_item.menu = ({
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
          end
          '';
        };

        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; } #-- For luasnip users.
          { name = "path"; }
          { name = "buffer"; }
        ];

        # confirm_opts = {
        #   behavior = "Replace";
        #   select = false;
        # };

        experimental.ghost_text = true;
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
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

    extraConfigLua = builtins.readFile ./nvim/main.lua + ''
      require'lspconfig'.volar.setup{
        filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
        init_options = {
          typescript = {
            serverPath = '${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/tsserverlibrary.js'
          }
        }
      }
    '';

    extraPackages = with pkgs; [
      # Language servers
      nodePackages.typescript
      nodePackages.typescript-language-server
      # nodePackages.vue-language-server
    ];
  };
}
