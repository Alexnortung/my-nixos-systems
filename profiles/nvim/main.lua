require('copilot').setup({
  suggestion = {
    auto_trigger = true,
  },
})

-- require("copilot_cmp").setup()

require'nvim-rename-state'.setup{}

require('template-string').setup({
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }, -- filetypes where the plugin is active
  jsx_brackets = true, -- must add brackets to jsx attributes
  remove_template_string = false, -- remove backticks when there are no template string
  restore_quotes = {
    -- quotes used when "remove_template_string" option is enabled
    normal = [[']],
    jsx = [["]],
  },
})

require("toggleterm").setup{
    open_mapping = [[<c-0>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals}
    direction = 'float',
    auto_scroll = true,
}

-- cmp.setup({
--     snippet = {
--         -- REQUIRED - you must specify a snippet engine
--         expand = function(args)
--             -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--             require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
--             -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--             -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--         end,
--     },
--     window = {
--         -- completion = {
--         --     side_padding = 0;
--         -- },
--         -- completion = cmp.config.window.bordered(),
--         -- documentation = cmp.config.window.bordered(),
--     },
--     mapping = cmp.mapping.preset.insert({
--         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ['<C-Space>'] = cmp.mapping.complete(),
--         ['<C-e>'] = cmp.mapping.abort(),
--         ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--         ['<Tab>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 cmp.select_next_item()
--             elseif luasnip.expandable() then
--                 luasnip.expand()
--             elseif luasnip.expand_or_jumpable() then
--                 luasnip.expand_or_jump()
--             elseif check_backspace() then
--                 fallback()
--             else
--                 fallback()
--             end
--         end, {
--             'i',
--             's',
--         }),
--         ['<S-Tab>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 cmp.select_prev_item()
--             elseif luasnip.jumpable(-1) then
--                 luasnip.jump(-1)
--             else
--                 fallback()
--             end
--         end, {
--             'i',
--             's',
--         })
--     }),
--     formatting = {
--         fields = { "kind", "abbr", "menu" },
--         format = function(entry, vim_item)
--             -- Kind icons
--             vim_item.kind = string.format(" %s ", kind_icons[vim_item.kind])
--             -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
--             vim_item.menu = ({
--                 luasnip = "[Snippet]",
--                 buffer = "[Buffer]",
--                 path = "[Path]",
--             })[entry.source.name]
--             return vim_item
--         end,
--     },
--     sources = {
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' }, -- For luasnip users.
--         { name = "path" },
--         { name = 'buffer' },
--     },
--
--     -- confirm_opts = {
--     --     behavior = cmp.ConfirmBehavior.Replace,
--     --     select = false,
--     -- },
--     -- documentation = {
--     --     border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
--     -- },
-- })
