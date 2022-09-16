""
"" VIM PLUGINS
""

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" git, github and code support
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" syntax highlighters
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }  " Golang
Plug 'pprovost/vim-ps1'                             " Powershell
Plug 'HerringtonDarkholme/yats.vim'                 " TypeScript/JavaScript

" fzf (fuzzy find) extension - fzf must be installed in homebrew
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" ripgrep is faster grep rewritten in rust
Plug 'jremmen/vim-ripgrep'

" themes
Plug 'folke/tokyonight.nvim'

" vim and tmux powerlines
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'


" Initialize plugin system
call plug#end()
" run :PlugInstall inside nvim to install

syntax enable
filetype plugin indent on

" Ruby CoC integ!
let g:coc_global_extensions = ['coc-solargraph']

""
"" GENERAL OPTIONS
""

" set how many lines of history to remember
set history=500
set encoding=UTF-8

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

" quick open files

" FZF/RipGrep
nnoremap <leader>O :grep<cr>
" courtesy of https://gist.github.com/danmikita/d855174385b3059cd6bc399ad799555e
nnorema <silent> <leader>o :call Fzf_dev()<CR>

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

" Files + devicons
function! Fzf_dev()
  let l:fzf_files_options = '--preview "bat --style=numbers,changes --color always {2..-1} | head -'.&lines.'"'

  function! s:files()
    let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:file_path = a:item[pos+1:-1]
    execute 'silent tabnew' l:file_path
  endfunction

  call fzf#run({
        \ 'source': <sid>files(),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'window': { 'width': 0.9, 'height': 0.6 } })
endfunction

" open fzf in a window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" hide statusline during fzf
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif

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

set expandtab
set showtabline=2 " always show tabline
set cursorline " hightlight the cursor's line

" 1 tab == 4 spaces
set shiftwidth=2
set tabstop=4

set ai "auto indent
set si "smart indent
set wrap "wrap lines

""
"" THEME SETTINGS
""
if (has("termguicolors"))
  set termguicolors
endif

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_italic_keywords = 0
let g:tokyonight_transparent = 1
colorscheme tokyonight " must run after tokyonight configuration

let g:lightline = {
      \ 'colorscheme': 'tokyonight',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
	  \              [ 'filetype', 'percent' ] ]
      \ },
	  \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
	  \ 'subseparator': { 'left': '', 'right': '' },
	  \ 'tabline_separator': { 'left': '', 'right': '' },
	  \ 'tabline_subseparator': { 'left': '|', 'right': '|' },
      \ 'tab': {
		    \ 'active': [ 'tabnum', 'devicon', 'filename', 'modified' ],
		    \ 'inactive': [ 'tabnum', 'devicon', 'filename', 'modified' ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'GitBranchName',
      \   'devicon': 'LightlineWebDevIcons',
	  \   'filetype': 'LightlineFiletype'
      \ },
      \ 'tab_component_function': {
      \   'devicon': 'LightlineWebDevIcons'
      \ }
\ }

function! GitBranchName()
  let gitbranch = FugitiveHead()
  return winwidth(0) > 70 ? (gitbranch !=# '' ? ' ' . gitbranch : '') : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? LightlineWebDevIcons() . ' ' . &filetype : 'no ft') : ''
endfunction

function! LightlineWebDevIcons(...)
  if a:0 == 0
    return WebDevIconsGetFileTypeSymbol()
  else
    let l:bufnr = tabpagebuflist(a:1)[tabpagewinnr(a:1) - 1]
    return WebDevIconsGetFileTypeSymbol(bufname(l:bufnr))
  endif
endfunction


" Tmuxline preset (what fields are displayed)
"let g:tmuxline_preset = {
"  \'a'           : '#S',
"  \'x'           : '#(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD)',
"  \'y'           : ['%Y-%m-%d', '%H:%M'],
"  \'z'           : '#h',
"  \'win'         : ['#I', '#W'],
"  \'cwin'        : ['#I', '#W'],
"  \'options'     : {
"     \'status-justify': 'left'},
"  \'win_options' : {
"     \'window-status-activity-style': 'none'}
"  \}

""
"" COC PLUGIN SETTINGS
""

" don't give |ins-completion-menu| messages.
"set shortmess+=c

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

""
"" OTHER SETTINGS
""

" fix go imports on save
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

" use an undo file
set undofile
" set a directory to store the undo history
set undodir=~/.config/nvim/undofiles/

let g:go_fmt_command = "goimports"

