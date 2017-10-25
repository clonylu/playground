execute pathogen#infect()
syntax on
"filetype plugin indent on

set tabstop=4
set expandtab
set autoindent
set hlsearch

"Nerdtree
"Start nerd tree if no file selected
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"F3 - Nerdtree shortcut
map <F3> :NERDTreeToggle<CR>

"Solarized theme
"syntax enable
"set background=dark
"colorscheme solarized
