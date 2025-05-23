" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Load vim-plug
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
    execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.config/nvim/plugged_minimal')
Plug 'jiangmiao/auto-pairs'
Plug 'tek/vim-fieldtrip'
Plug 'AndrewRadev/sideways.vim'
Plug 'kana/vim-submode'
Plug 'junegunn/vim-easy-align'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-commentary'
Plug 'leafgarland/typescript-vim'
Plug 'vim-airline/vim-airline'
Plug 'zivyangll/git-blame.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'm-demare/hlargs.nvim'
call plug#end()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" backups
set nobackup
set nowritebackup
set noswapfile
set undofile
set undodir=~/.config/nvim/undo

filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set title

" Show line number
set number
set relativenumber

" Indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround
set expandtab
set smartindent

" search
set ignorecase
set smartcase
set history=25    " keep 50 lines of command line history
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set wildmenu
set hlsearch

set ruler         " show the cursor position all the time

" allow unsaved buffers to be hidden
set hidden

" you are tearing me apart, Lisa!
set splitbelow
set splitright

" show whitespace
set list
set listchars=nbsp:.,trail:.,tab:>-,space:.

" text wrapping
set textwidth=100
set wrap

" folder
set foldmethod=indent

" colors
colorscheme vim
set notermguicolors

let mapleader = " "

" todo list mapping
nnoremap <leader>- o<Esc>0i- [ ] 
nnoremap <leader>_ o<Esc>0i<tab>- [ ] 
nnoremap <leader>c 0f[lrx
nnoremap <leader>u 0f[lr<space>
nnoremap <leader>p 0f[lr-

let g:fieldtrip_start_map = "<leader>f"

" expand
map ,e :e <C-R>=expand("%:h") . "/" <CR>
map ,t :tabe <C-R>=expand("%:h") . "/" <CR>
map ,s :split <C-R>=expand("%:h") . "/" <CR>
map ,v :vsplit <C-R>=expand("%:h") . "/" <CR>

" EasyAlign mapping
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Shut up Karen!
silent! so .vimlocal

" ALE
let g:ale_linters = {
 \ 'javascript': ['eslint'],
 \ 'astro': ['eslint'],
 \ 'markdown': ['languagetool'],
 \ 'text': ['languagetool'],
 \ }

let g:ale_fixers = {
 \ 'javascript': ['prettier'],
 \ 'astro': ['prettier'],
 \ }

let g:ale_fix_on_save = 1
let g:ale_languagetool_language = 'es,en-US'
let g:ale_echo_cursor = 0
let g:ale_hover_cursor = 1
let g:ale_virtualtext_cursor = 1

nnoremap <Leader>an :AlENext<CR>
nnoremap <Leader>ap :ALEPrevious<CR>
nnoremap <Leader>ad :ALEDetail<CR>
nnoremap <Leader>at :ALEToggle<CR>
nnoremap <Leader>af :ALEFix<CR>
nnoremap <Leader>as :ALEFixSuggest<CR>
nnoremap <Leader>al :ALELint<CR>

" Habilitar spell checking en español
set spell
set spelllang=es,en
set spellsuggest=best,9
set spelloptions=camel
syntax spell toplevel

nnoremap <Leader>sn ]s
nnoremap <Leader>sp [s
nnoremap <Leader>sf z=
nnoremap <Leader>sg zg
nnoremap <Leader>sw zw
nnoremap <Leader>su zu

nnoremap <Leader>b :<C-u>call gitblame#echo()<CR>
