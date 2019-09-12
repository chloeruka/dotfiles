


" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" fzf (fuzzy find) extension - sourced frome homebrew
Plug '/usr/local/opt/fzf'

" Initialize plugin system
call plug#end()

""
"" GENERAL OPTIONS
""

" set how many lines of history to remember
set history=500

" mouse/scroll support
set mouse=a

" use mac clipboard
set clipboard=unnamed

" enable line numbers
set number

" set to auto read when a file is changed from the outside
set autoread

" map leader key
let mapleader = ","

" fast writing of files
nmap <leader>w :w!<cr>

" split options to split in more intuitive directions
set splitbelow
set splitright

" ignore case when searching, use smartcase
set ignorecase
set smartcase

" turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

""
"" FORMATTING SETTINGS
"" 

set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set ai "auto indent
set si "smart indent
set wrap "wrap lines

""
"" THEME SETTINGS
""
" make line numbers blue instead of default
highlight LineNr ctermfg=blue


