syntax on
filetype on
let mapleader = ","

" Use Nord color scheme
" !IMPORTANT: set the variables before setting the color scheme
let g:nord_borders = v:true
let g:nord_contrast = v:true
colorscheme nord

set nocompatible " for some reason important
set number relativenumber " Sets line numbers, but relative and sets the line number for the current line

" Use spaces on tab
set expandtab
set shiftwidth=4
set tabstop=4

" Use mouse
set mouse=a

" Use system clipboard
set clipboard=unnamedplus

" By cmp
set completeopt=menu,menuone,noselect

" makes you move up or down as you would see it visually
nnoremap j gj
nnoremap k gk

" vim-tex
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_syntax_packages = {'minted': {'load': 2}}
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

let g:Tex_IgnoredWarnings = 
    \'Underfull'."\n".
    \'Overfull'."\n".
    \'specifier changed to'."\n".
    \'You have requested'."\n".
    \'Missing number, treated as zero.'."\n".
    \'There were undefined references'."\n".
    \'Citation %.%# undefined'."\n".
    \'Double space found.'."\n".
    \'package is obsolete'."\n"

" Javascript
"let g:javascript_plugin_jsdoc = 1;

" Nerdtree
"nmap <leader>n :NERDTreeToggle<CR>
"let NERDTreeShowHidden = 1
"let g:NERDTreeWinPos = "right"
"let g:NERDTreeWinSize = 35

" Nvim tree
nmap <leader>nn :NvimTreeToggle<CR>
nmap <leader>nf :NvimTreeFindFile<CR>
let g:nvim_tree_highlight_opened_files = 1 " will enable folder and file icon highlight for opened files/directories.

" Rainbow
let g:rainbow_active = 1

" FZF
"nmap <leader>p :FZF<CR>

" Telescope
nmap <leader>p <cmd>Telescope find_files<CR>
nmap <leader>ff <cmd>Telescope find_files<CR>
nmap <leader>fhf <cmd>Telescope find_files hidden=true<CR>
nmap <leader>fl <cmd>Telescope live_grep<CR>
nmap <leader>fhl <cmd>Telescope live_grep hidden=true<CR>
nmap <leader>fb <cmd>Telescope buffers<CR>
nmap <leader>fp <cmd>Telescope projects<CR>
nmap <leader>fgs <cmd>Telescope git_status<CR>
nmap <leader>fgc <cmd>Telescope git_commits<CR>
nmap <leader>fgb <cmd>Telescope git_branches<CR>

" Bufferline
nmap <leader>bp <cmd>BufferLinePick<CR>
nmap <leader>bmn <cmd>BufferLineMoveNext<CR>
nmap <leader>bmb <cmd>BufferLineMovePrev<CR>
nmap <leader>bcl <cmd>BufferLineCloseLeft<CR>
nmap <leader>bcr <cmd>BufferLineCloseRight<CR>

" Buffers
nmap <leader>bb <cmd>bprevious<CR>
nmap <leader>bn <cmd>bnext<CR>
nmap <A-w> <cmd>bdelete %<CR>

" Dashboard
let g:dashboard_default_executive ='telescope'


let g:dashboard_custom_header = [
  \'              ▄▄                               ',
  \'▀███▄   ▀███▀ ██             ▄▄█▀▀██▄  ▄█▀▀▀█▄█',
  \'  ███▄    █                ▄██▀    ▀██▄██    ▀█',
  \'  █ ███   █ ▀███ ▀██▀   ▀██▀█▀      ▀█████▄    ',
  \'  █  ▀██▄ █   ██   ▀██ ▄█▀ ██        ██ ▀█████▄',
  \'  █   ▀██▄█   ██     ███   ██▄      ▄██     ▀██',
  \'  █     ███   ██   ▄█▀ ██▄ ▀██▄    ▄██▀█     ██',
  \'▄███▄    ██ ▄████▄██▄   ▄██▄ ▀▀████▀▀ █▀█████▀ ',
    \ ]

" Pear tree - smart closing of brackets
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_repeatable_expand = 0

" Blank line
" let g:indentLine_enabled = v:true
" let g:indent_blankline_show_current_context = v:true
" let g:indent_blankline_show_current_context_start = v:true
" " let g:indent_blankline_use_treesitter = v:true
" let g:indent_blankline_context_patterns = [
"     \'class',
"     \'function',
"     \'method',
"     \'^if',
"     \'^while',
"     \'^typedef',
"     \'^for',
"     \'^object',
"     \'^table',
"     \'block',
"     \'arguments',
"     \'typedef',
"     \'while',
"     \'^public',
"     \'return',
"     \'if_statement',
"     \'else_clause',
"     \'jsx_element',
"     \'jsx_self_closing_element',
"     \'try_statement',
"     \'catch_clause',
"     \'import_statement',
"     \'labeled_statement',
"     \'struct'
"     \]

" COC
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" 
" let g:coc_snippet_next = '<tab>'

" Snippets
" let g:UltiSnipsExpandTrigger="<c-tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Emmet
let g:user_emmet_mode='n'    "only enable normal mode functions.
let g:user_emmet_mode='inv'  "enable all functions, which is equal to
let g:user_emmet_mode='a'    "enable all function in all mode.
let g:user_emmet_install_global = 1
let g:user_emmet_leader_key='<C-Z>'

" Svelte
" let g:vim_svelte_plugin_load_full_syntax = 1
let g:vim_svelte_plugin_use_typescript = 1
let g:vim_svelte_plugin_use_sass = 1
let g:vim_svelte_plugin_use_less = 1

" Code actions
nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
" Hover
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
" show signature help
nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
" preview definition
nnoremap <silent> gp <cmd>lua require'lspsaga.provider'.preview_definition()<CR>

" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" auto-format
autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
" autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)

lua <<EOF
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  auto_close          = true,
  open_on_tab         = true,
  hijack_cursor       = false,
  update_cwd          = false,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'right',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {}
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  }
}

vim.opt.termguicolors = true -- used by bufferline
require('bufferline').setup {
  options = {
    close_command = "bdelete %d",
    right_mouse_command = nil,
    left_mouse_command = "buffer! %d",
    middle_mouse_command = nil,
    indicator_icon = '▎',
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',

    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    --diagnostics = false | "nvim_lsp" | "coc",
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    --diagnostics_indicator = function(count, level, diagnostics_dict, context)
    --  return "("..count..")"
    --end,
    show_buffer_icons = true, -- disable filetype icons for buffers
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    separator_style = "thin",
    always_show_bufferline = true
  }
}

local cmp = require('cmp')
local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')
cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(
      function(fallback)
        cmp_ultisnips_mappings.compose { "jump_forwards" } (fallback)
      end
    ),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  --sources = cmp.config.sources({
  --  { name = 'nvim_lsp' },
  --  { name = 'ultisnips' }, -- For ultisnips users.
  --}, {
  --  { name = 'buffer' },
  --})
  sources = {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }, -- For ultisnips users.
    { name = 'buffer' },
  },
  experimental = {
    native_menu = true
  }
}

require("tailwindcss-colors").setup()

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')

require('lsp_signature').on_attach()
local on_attach = function(client, bufnr)
  require'lsp_signature'.on_attach()
end

local saga = require 'lspsaga'
saga.init_lsp_saga()

-- enable language servers
local servers = { 'pyright', 'svelte', 'rust_analyzer', 'tsserver', 'emmet_ls', 'gdscript', 'texlab', 'phpactor', 'rnix' }
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

lspconfig.tailwindcss.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    require'lsp_signature'.on_attach()
    require("tailwindcss-colors").buf_attach(bufnr)
  end
}

EOF
