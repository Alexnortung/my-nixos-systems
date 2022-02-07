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
nmap <A-w> <cmd>bdelete<CR>

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
let g:indentLine_enabled = v:true
let g:indent_blankline_show_current_context = v:true
let g:indent_blankline_show_current_context_start = v:true
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_context_patterns = [
    \'class',
    \'function',
    \'method',
    \'^if',
    \'^while',
    \'^typedef',
    \'^for',
    \'^object',
    \'^table',
    \'block',
    \'arguments',
    \'typedef',
    \'while',
    \'^public',
    \'return',
    \'if_statement',
    \'else_clause',
    \'jsx_element',
    \'jsx_self_closing_element',
    \'try_statement',
    \'catch_clause',
    \'import_statement',
    \'labeled_statement',
    \'struct'
    \]

" COC
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Emmet
let g:user_emmet_mode='n'    "only enable normal mode functions.
let g:user_emmet_mode='inv'  "enable all functions, which is equal to
let g:user_emmet_mode='a'    "enable all function in all mode.
let g:user_emmet_install_global = 1

" Svelte
"let g:vim_svelte_plugin_load_full_syntax = 1
let g:vim_svelte_plugin_use_typescript = 1
let g:vim_svelte_plugin_use_sass = 1
let g:vim_svelte_plugin_use_less = 1

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
    diagnostics = "coc",
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

EOF
