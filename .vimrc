" Charles H. Leggett's .vimrc
" there are many like it, but this one is mine.

" ##############################################################################
"  Vundle Config

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add plugins
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
"Plugin 'mrtazz/simplenote.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" ##############################################################################
"  Main Config

" Highlight the current line
set cursorline

" Set laststatus to 2 (always) to show status bar for vim-airline
set laststatus=2

" Allow cursor to move anywhere regardless of the underlying text
set virtualedit=all

" Auto fold based on syntax
set foldmethod=syntax

" Add a $ to the end of a change buffer
set cpoptions+=$

" Toggle line numbers on and of by typing \n
map \n :set invnu<CR>

" Toggle highlighting after a search on and off by typing \h
map \h :nohl<CR>

" Toggle line wrapping  on and off by typing \w
map \w :set invwrap<CR>

" Add keymappings to move between splits faster
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


" ##############################################################################
"  Colorscheme Config

" Enable syntax highlighting
syntax enable

set background=dark

" Set colorscheme to solarized
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized


" ##############################################################################
"  VimPager Config

" Turn off scroll for VimPager to unbreak search
" https://github.com/rkitover/vimpager/issues/30
let vimpager_scrolloff = 0


" ##############################################################################
"  NERDTree Config

" Toggle NERDTree on and off by typing \\
map \\ :NERDTreeToggle<CR>

" Make NERDTree cd to directory when root is changed
let NERDTreeChDirMode=2

" Show NERDTree bookmarks by default.
let NERDTreeShowBookmarks=1

" Quit NERDTree after a file is opened
let NERDTreeQuitOnOpen=1


"" ##############################################################################
""  Simplenote Config
"
"" Load Simplenote credentials from .simplenoterc
"source ~/.simplenoterc
"
"" Set height of Simplenote list
"let g:SimplenoteListHeight=30
"
"" Query and list Simplenotes
"map \s :Simplenote -l<CR>
"
"" New Simplenote
"map \a :Simplenote -n<CR>
"
"" Tag Simplenote
"map \t :Simplenote -t<CR>
"
"" Trash Simplenote
"map \d :Simplenote -d<CR>
"
