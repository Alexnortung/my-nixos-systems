syntax on
filetype on
let mapleader = ","

" Use Nord color scheme
colorscheme nord
let g:nord_borders = 1

set nocompatible " for some reason important
set number relativenumber " Sets line numbers, but relative and sets the line number for the current line

" Use spaces on tab
set expandtab
set shiftwidth=4

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
nmap <leader>n :NvimTreeToggle<CR>
let g:nvim_tree_highlight_opened_files = 1 " will enable folder and file icon highlight for opened files/directories.

" Rainbow
let g:rainbow_active = 1

" FZF
"nmap <leader>p :FZF<CR>

" Telescope
nmap <leader>p <cmd>Telescope find_files<CR>
nmap <leader>hp <cmd>Telescope find_files hidden=true<CR>
nmap <leader>f <cmd>Telescope live_grep<CR>
nmap <leader>hf <cmd>Telescope live_grep hidden=true<CR>

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


EOF
