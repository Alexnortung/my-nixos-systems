{ inputs, pkgs, system, config, ... }:

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
      # Close buffer
      normal."<A-w>" = ":Bdelete!<CR>";

      # Indent, stay in visual mode
      visual."<" = "<gv";
      visual.">" = ">gv";

      # Move text under cursor up and down
      visual."<A-j>" = ":m .+1<CR>==";
      visual."<A-k>" = ":m .-2<CR>==";

      # When pasting in visual mode, do not yank the replaces text
      visual."p" = "\"_dP";

      # Nvim tree
      normal."<leader>nn" = ":NvimTreeToggle<CR>";
      normal."<leader>nf" = ":NvimTreeFindFile<CR>";
      normal."<leader>nr" = ":NvimTreeRefresh<CR>";

      # LSP stuff
      normal."gD" = "<cmd>lua vim.lsp.buf.declaration()<CR>";
      normal."gd" = "<cmd>lua vim.lsp.buf.definition()<CR>";
      normal."K" = "<cmd>lua vim.lsp.buf.hover()<CR>";
      normal."gi" = "<cmd>lua vim.lsp.buf.implementation()<CR>";
      # normal."<C-k>" = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
      normal."gr" = "<cmd>lua vim.lsp.buf.references()<CR>";
      normal."<leader>ck" = "<cmd>lua vim.diagnostic.open_float()<CR>";
      normal."<leader>ca" = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      normal."<leader>cf" = "<cmd>lua vim.lsp.buf.formatting_sync()<CR>";

      # Telescope
      normal."<leader>p" = "<cmd>Telescope find_files<CR>";
      normal."<leader>ff" = "<cmd>Telescope find_files<CR>";
      normal."<leader>fl" = "<cmd>Telescope live_grep<CR>";
      normal."<leader>fr" = "<cmd>Telescope resume<CR>";
      normal."<leader>fp" = "<cmd>Telescope projects<CR>";

      # Gitsigns
      normal."<leader>hs" = "<cmd>Gitsigns stage_hunk<CR>";
      visual."<leader>hs" = "<cmd>Gitsigns stage_hunk<CR>";
      normal."<leader>hr" = "<cmd>Gitsigns reset_hunk<CR>";
      visual."<leader>hr" = "<cmd>Gitsigns reset_hunk<CR>";
      normal."<leader>hb" = "<cmd>Gitsigns blame_line<CR>";
      normal."<leader>hd" = "<cmd>Gitsigns diffthis<CR>";
      normal."<leader>hp" = "<cmd>Gitsigns preview_hunk<CR>";
      normal."<leader>hn" = "<cmd>Gitsigns next_hunk<CR>";
      normal."<leader>hN" = "<cmd>Gitsigns prev_hunk<CR>";
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
          tsserver.enable = true;
          vuels.enable = true;
          elixirls.enable = true;
        };
      };

      lsp-lines = {
        # enable = true;
      };

      project-nvim = {
        enable = true;
        manualMode = true;
      };

      telescope = {
        enable = true;
        defaultsConfig = {
          # path_display = "smart";
          winblend = 5;
          borderchars = [ " " " " " " " " " " " " " " " " ];
          border = [];
          prompt_prefix = " 🤓 ";
          entry_prefix = "   ";
          selection_caret = "🤌 ";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              results_width = 0.5;
              preview_width = 0.5;
            };
          };
        };
        extensions = {
          project-nvim = {
            enable = true;
          };
        #   media_files = {
        #     enable = true;
        #     find_cmd = "rg";
        #     # find_cmd = "${pkgs.ripgrep}/bin/rg";
        #   };
        };
      };

      nvim-tree = {
        enable = true;

        disableNetrw = true;
        hijackNetrw = true;

        # syncRootWithCwd = true;
        updateCwd = true;
        # respectBufCwd = true;
        updateFocusedFile = {
          enable = true;
          # updateRoot = true;
          updateCwd = true;
        };

        git = {
          enable = true;
          ignore = true;
          timeout = 500;
        };

        view = {
          side = "right";
          mappings = {
            customOnly = false;
            list = [
              {
                 key = [ "l" "<CR>" "o" ];
                 cb = {__raw = ''require("nvim-tree.config").nvim_tree_callback "edit"''; }; 
              }
              {
                key = "h";
                cb = { __raw = ''require("nvim-tree.config").nvim_tree_callback "close_node"''; };
              }
              {
                key = "v";
                cb = { __raw = ''require("nvim-tree.config").nvim_tree_callback "vsplit"''; };
              }
                # { key = "v", cb = require("nvim-tree.config").nvim_tree_callback "vsplit" },
            ];
          };
        };

        trash = {
          cmd = "trash";
          requireConfirm = true;
        };

        diagnostics = {
          enable = true;
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

      bufferline = let
        closeCommand = "Bdelete! %d";
      in {
        inherit closeCommand;
        enable = true;
        rightMouseCommand = null;
        middleMouseCommand = closeCommand;
        indicatorIcon = "▎";
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
        indent = true;
        ensureInstalled = "all";
      };

      nvim-cmp = {
        enable = true;
        # preselect = "None";
        snippet.expand = ''
          function(args)
            luasnip.lsp_expand(args.body)
          end
        '';
        mappingPresets = [ "insert" "cmdline" ];
        mapping = {
          "<C-b>" = ''cmp.mapping.scroll_docs(-4)'';
          "<C-f>" = ''cmp.mapping.scroll_docs(4)'';
          "<C-Space>" = ''cmp.mapping.complete({
            config = {
              sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
                { name = "buffer" },
              }
            }
          })'';
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                if luasnip.jumpable(1) then
                  luasnip.jump(1)
                elseif cmp.visible() then
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
              vim_item.kind = string.format(" %s ", kind_icons[vim_item.kind])
              -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
          end
          '';
        };

        # window = {
        #   # completion = {
        #   #   side_padding = 0;
        #   # };
        # };

        sources = [
          { name = "luasnip"; } #-- For luasnip users.
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];

        # confirm_opts = {
        #   behavior = "Replace";
        #   select = false;
        # };

        experimental.ghost_text = true;
      };

      null-ls = {
        enable = true;
        sources.formatting = {
          prettier.enable = true;
          alejandra.enable = true;
          phpcbf.enable = true;
        };
      };

      luasnip = {
        enable = true;

        fromVscode = [
          {
            lazyLoad = true;
          }
          {
            lazyLoad = true;
            paths = [
              ./snippets
            ];
          }
        ];
      };
    };

    extraPlugins = with inputs.nixpkgs-unstable.legacyPackages.${system}.vimPlugins; [
      yuck-vim
      editorconfig-nvim
      friendly-snippets
      vim-sleuth # detects indentation
      futhark-vim # Futhark programming language
      # gitsigns-nvim
      pkgs.vimPlugins.gitsigns-nvim
      which-key-nvim
      nvim-ts-rainbow # treesitter color brackets
      nvim-ts-autotag
      (inputs.vim-extra-plugins.packages.${system}.nvim-ts-context-commentstring.overrideAttrs (oldAttrs: {
        dependencies = [];
      }))
      vim-bbye
      Jenkinsfile-vim-syntax
      toggleterm-nvim
      template-string-nvim
      nvim-rename-state
      lsp_signature-nvim
    ];

    # plugins.lightline.enable = true;
    colorschemes.nord = {
      enable = true;
      borders = true;
      contrast = true;
    };

    extraConfigLua = builtins.readFile ./main.lua 
    # + ''
    #   require'lspconfig'.volar.setup{
    #     filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
    #     init_options = {
    #       typescript = {
    #         serverPath = '${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/tsserverlibrary.js'
    #       }
    #     }
    #   }
    # ''
    ;

    extraConfigVim = builtins.readFile ./main.vim;

    extraConfigLuaPre= builtins.readFile ./pre.lua;
    extraConfigLuaPost = builtins.readFile ./post.lua;

    extraPackages = with pkgs; [
      # Language servers
      nodePackages.typescript
      nodePackages.typescript-language-server
      ripgrep
    ];
  };
}
