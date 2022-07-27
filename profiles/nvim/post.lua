npairs.setup {
    check_ts = true,
}

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

require('nvim-treesitter.configs').setup {
    ['ensure_installed'] = 'all',
    ['highlight'] = {
        ['enable'] = true
    },
    ['indent'] = {
        ['enable'] = true
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
}

require('Comment').setup {
    pre_hook = function(ctx)
        local U = require 'Comment.utils'

        local location = nil
        if ctx.ctype == U.ctype.block then
            location = require('ts_context_commentstring.utils').get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
        end

        return require('ts_context_commentstring.internal').calculate_commentstring {
            key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
            location = location,
        }
    end,
}

--require'lspconfig'.volar.setup{
--    filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
--}

require('gitsigns').setup {
}
local wk = require("which-key")
wk.setup {
}

wk.register {
    ["<leader>"] = {
        f = {
            name = "+file",
        },
        h = {
            name = "+git",
        },
        c = {
            name = "+code";
        },
    },
}

local nord_colors = require("nord.colors")
local kind_text = nord_colors.nord6_gui
local cmp_colors = {
    -- CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", fmt = "strikethrough" },
    -- CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE", fmt = "bold" },
    -- CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE", fmt = "bold" },
    -- CmpItemMenu = { fg = "#C792EA", bg = "NONE", fmt = "italic" },

    CmpItemKindField = { fg = kind_text, bg = nord_colors.nord11_gui },
    CmpItemKindProperty = { fg = kind_text, bg = nord_colors.nord11_gui },
    CmpItemKindEvent = { fg = kind_text, bg = nord_colors.nord11_gui },

    CmpItemKindText = { fg = kind_text, bg = nord_colors.nord14_gui },
    CmpItemKindEnum = { fg = kind_text, bg = nord_colors.nord14_gui },
    CmpItemKindKeyword = { fg = kind_text, bg = nord_colors.nord14_gui },

    CmpItemKindConstant = { fg = kind_text, bg = nord_colors.nord13_gui },
    CmpItemKindConstructor = { fg = kind_text, bg = nord_colors.nord13_gui },
    CmpItemKindReference = { fg = kind_text, bg = nord_colors.nord13_gui },

    CmpItemKindFunction = { fg = kind_text, bg = nord_colors.nord15_gui },
    CmpItemKindStruct = { fg = kind_text, bg = nord_colors.nord15_gui },
    CmpItemKindClass = { fg = kind_text, bg = nord_colors.nord15_gui },
    CmpItemKindModule = { fg = kind_text, bg = nord_colors.nord15_gui },
    CmpItemKindOperator = { fg = kind_text, bg = nord_colors.nord15_gui },

    CmpItemKindVariable = { fg = kind_text, bg = nord_colors.nord9_gui },
    CmpItemKindFile = { fg = kind_text, bg = nord_colors.nord9_gui },

    CmpItemKindUnit = { fg = kind_text, bg = nord_colors.nord13_gui },
    CmpItemKindSnippet = { fg = kind_text, bg = nord_colors.nord13_gui },
    CmpItemKindFolder = { fg = kind_text, bg = nord_colors.nord13_gui },

    CmpItemKindMethod = { fg = kind_text, bg = nord_colors.nord10_gui },
    CmpItemKindValue = { fg = kind_text, bg = nord_colors.nord10_gui },
    CmpItemKindEnumMember = { fg = kind_text, bg = nord_colors.nord10_gui },

    CmpItemKindInterface = { fg = kind_text, bg = nord_colors.nord7_gui },
    CmpItemKindColor = { fg = kind_text, bg = nord_colors.nord7_gui },
    CmpItemKindTypeParameter = { fg = kind_text, bg = nord_colors.nord7_gui },
}

for name, values in pairs(cmp_colors) do
    -- local temp_map = vim.api.nvim_get_hl_by_name(name, true)
    -- for attr, value in pairs(values) do temp_map[attr] = value end
    -- vim.api.nvim_set_hl(0, name, temp_map)
    vim.api.nvim_set_hl(0, name, values)
    -- vim.cmd(string.format('highlight! %s guifg=%s guibg=%s', name, values.fg, values.bg))
    -- print(name)
    -- print(values)
end
