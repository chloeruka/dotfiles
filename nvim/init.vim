" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Typescript syntax file
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" For async completion
Plug 'Shougo/deoplete.nvim'
" For Denite features
Plug 'Shougo/denite.nvim'

" Initialize plugin system
call plug#end()

let g:deoplete#enable_at_startup = 1

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

