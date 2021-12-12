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
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize = 35

" Rainbow
let g:rainbow_active = 1

" FZF
nmap <leader>p :FZF<CR>

" Pear tree - smart closing of brackets
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_repeatable_expand = 0

" Blank line
g:indentLine_enabled = v:true
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
