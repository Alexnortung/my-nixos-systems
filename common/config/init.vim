let mapleader = ","

set nocompatible " for some reason important
set number relativenumber " Sets line numbers, but relative and sets the line number for the current line

" Use spaces on tab
set expandtab
set shiftwidth=4

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


" Javascript
"let g:javascript_plugin_jsdoc = 1;

" Nerdtree
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize = 25

" Rainbow
let g:rainbow_active = 1

" FZF
nmap <leader>p :FZF<CR>

" Pear tree - smart closing of brackets
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_repeatable_expand = 0
