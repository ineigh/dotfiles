"colors (oblivion)
let g:aldmeris_transparent = 1
colorscheme aldmeris
syntax on

"fluttershy welcome message
"function! s:show_fluttershy()
"  if argc() == 0 && !exists("s:art_shown")
"    silent! enew
"    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
"    call append(0, readfile(expand('~/.fluttershy.txt')))
"    setlocal nomodifiable
"    let s:art_shown = 1
"  endif
"endfunction

"autocmd VimEnter * call s:show_fluttershy()

"tab spaces
set tabstop=4
set shiftwidth=4
set expandtab

"autoindent tweaks
filetype plugin indent on
"let g:sh_indent_case_labels = 1

"enable mouse
set mouse=a

"highlight current line
set cursorline

"highlight parenthesis and brackets
set showmatch

"scrolloff
"set scrolloff=3

"allow cursor to reach end of line in normal mode
"set virtualedit=onemore

"enable ctrl+bs
inoremap <C-h> <C-w>
"inoremap <C-?> <C-w>
"inoremap <C-BS> <C-w>

"autoindent
set autoindent
set smartindent

"number lines
set relativenumber
set number

"yank and paste using the system clipboard
set clipboard^=unnamed,unnamedplus

"search
set ignorecase          "disable case sensitivity when searching
set smartcase           "unless if it's in all caps
set incsearch           "highlights as you type
set hlsearch            "highlight results
nnoremap <Esc><Esc> :nohlsearch<CR>  "double esc removes highlighting 

"interface misc
set showcmd             "show partial commands in cmd
set laststatus=2        "always show status bar
set wildmenu            "visual autocomplete in cmd
set wildmode=longest:full,full
set shortmess+=c        "less verbose
set updatetime=500      "update cursor faster

"ctrl+s = :w
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
