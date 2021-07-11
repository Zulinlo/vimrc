" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Load plugins here (vim-plug)
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'neoclide/coc.nvim', {'branch': 'release'} " autocompletion
Plug 'tpope/vim-sensible'       " setup .vimrc
Plug 'jacoborus/tender.vim'     " Tender: colorscheme
Plug 'itchyny/lightline.vim'    " Lightline: status bar
Plug 'mg979/vim-visual-multi', {'branch': 'master'}   " edit multiple lines at once
Plug 'preservim/nerdtree'       " NERDTree: navigation tree
Plug 'preservim/nerdcommenter'  " NERDComment: comment blocks with ,cc and uncomment with ,cu + more
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'   " Git Gutter: show git changes
Plug 'junegunn/fzf'             " search for fuzzy files with :FZF
Plug 'tmsvg/pear-tree'          " Pear Tree: auto bracket completion
Plug 'pangloss/vim-javascript'  " Javascript syntax
Plug 'dense-analysis/ale'       " ALE: asynchronous linter
Plug 'leafgarland/typescript-vim' " Prettier typescript
Plug 'maxmellon/vim-jsx-pretty' " Pretty jsx
Plug 'SirVer/ultisnips'         " Ultisnips

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" coc config
let g:coc_global_extensions = [
      \ 'coc-prettier'
      \]

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" On start run nerdtree and close if last
autocmd VimEnter * NERDTree | wincmd p | call lightline#update()
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
autocmd BufEnter * lcd %:p:h

"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:lightline = {
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ },
  \ }

function! LightlineFilename()
  return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
        \ &filetype ==# 'unite' ? unite#get_status_string() :
        \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
        \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" On save update git
autocmd BufWritePost * GitGutter

" ALE
let g:ale_linters = {
\   'python': ['flake8'],
\   'java': ['javac'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\}

let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1

" FZF relative search
inoremap <expr> <c-x><c-f> CompleteRelativePath()
func! CompleteRelativePath()
    :cd %:h
    call fzf#vim#complete#path("find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'")
    return ""
endfu

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

" Pick a leader key
let mapleader = ","

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

set cmdheight=2
set updatetime=300
set shortmess+=c

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" for python/java files, 4 spaces
autocmd Filetype python setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype java setlocal ts=4 sw=4 sts=0 expandtab

" Increase Yank amount
set viminfo='100,<1000,s100,h

" Stop auto wrapping
set textwidth=0
set wrapmargin=0

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2
set noshowmode

" Last line
set showmode
set showcmd

" Clipboard to be shared across vim instances
set clipboard^=unnamed

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" now it is possible to paste many times over selected text
xnoremap <expr> p 'pgv"'.v:register.'y`>'
xnoremap <expr> P 'Pgv"'.v:register.'y`>'
" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
map <leader>l :set list!<CR> " Toggle tabs and EOL

" Color scheme (terminal)
colorscheme tender

