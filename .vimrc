"colors (oblivion)
let g:aldmeris_transparent = 1
colorscheme aldmeris
syntax on

"tab spaces
set tabstop=4
set shiftwidth=4

"allow cursor to reach end of line in normal mode
set virtualedit=onemore

"enable ctrl+bs
inoremap <C-h> <C-w>
inoremap <C-?> <C-w>
inoremap <C-BS> <C-w>

"autoindent
set autoindent
set smartindent

"number lines
set relativenumber
set number

"yank and paste using the system clipboard
set clipboard=unnamedplus

"show normal mode commands even when incomplete
set showcmd
