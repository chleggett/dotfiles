" Charles H. Leggett's .vimrc
" There are many like it, but this one is mine.

" Vundle Config """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add plugins
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on

" Main Config """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set backspace=2        " Make backspace work like it does most other apps (indent,eol,start)
set shiftwidth=4       " Indent 4 columns
set textwidth=80       " Wrap after 80 columns
set cpoptions+=$       " Add a $ to the end of a change buffer
set incsearch          " Incremental search as you type characters
set hlsearch           " Highlight search results
set cursorline         " Highlight the current line
set hidden             " Use hidden buffers by default
set laststatus=2       " Set laststatus to always to show status bar
set virtualedit=all    " Allow cursor to move anywhere regardless of the underlying text
set foldmethod=syntax  " Auto fold based on syntax
set splitbelow         " Open horizontal splits below
set splitright         " Open vertical splits to the right

" Colorscheme """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax enable
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

" Shortcuts and Keybindings """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader=" "                " Change the <Leader> key
map <Leader>n    :set invnu<CR>  " Toggle line numbers by typing <Leader>n
map <Leader>h    :nohl<CR>       " Disable highlighting after a search
map <Leader>c    "*y<CR>         " Yank selection to system clipboard

" Keybindings for buffers
map <Leader>bb   :buffers<CR>:buffer<Space>
map <Leader>bl   :buffers<CR>:buffer<Space>
map <Leader>bn   :bnext<CR>
map <Leader>bp   :bprevious<CR>
map <Leader>bd   :bdelete<CR>

" Keybindings for window splits
nnoremap <C-w>n  :vnew<CR>

" Keybindings for tabs
nnoremap <C-t>   :tabnew<CR>
nnoremap <C-t>n  :tabnew<CR>
nnoremap <C-t>l  :tabnext<CR>
nnoremap <C-t>h  :tabprevious<CR>
nnoremap <C-t>c  :tabclose<CR>

" Make calls to help open in a vertical split
cnoreabbrev <expr> help ((getcmdtype() is# ':' && getcmdline() is# 'help')?('vert help'):('help'))
cnoreabbrev <expr> h ((getcmdtype() is# ':' && getcmdline() is# 'h')?('vert h'):('h'))

" VimPager """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn off scroll for VimPager to unbreak search (https://github.com/rkitover/vimpager/issues/30)
let vimpager_scrolloff = 0 

" NERDTree Config """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <Leader>\  :NERDTreeToggle<CR>  " Toggle NERDTree on and off by typing <Leader>\
let NERDTreeChDirMode=2             " Make NERDTree cd to directory when root is changed
let NERDTreeShowBookmarks=1         " Show NERDTree bookmarks by default.
let NERDTreeQuitOnOpen=1            " Quit NERDTree after a file is opened

