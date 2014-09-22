" Charles H. Leggett's .vimrc
" there are many like it, but this one is mine.

" BEGIN Vundle Config

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Vundle examples
" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" " plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

Plugin 'nanotech/jellybeans.vim'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'mrtazz/simplenote.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" END Vundle Config

" Set laststatus to 2 (always) to show status bar for vim-airline
set laststatus=2

" Set colorscheme to jellybeans, but override some of its colors.
colorscheme jellybeans
highlight Folded term=standout ctermfg=59 ctermbg=NONE guifg=#535D66 guibg=#151515
highlight FoldColumn term=standout ctermfg=59 ctermbg=NONE guifg=#535D66 guibg=#151515
highlight Comment term=bold ctermfg=59 guifg=#535D66
highlight Normal ctermbg=NONE
highlight NonText ctermbg=NONE
highlight LineNr ctermbg=NONE

" Enable syntax highlighting
syntax on

" Highlight the current line
set cursorline

" Set font for MacVim/gVim
set guifont=Menlo\ Regular:h14

" Auto fold based on syntax
set foldmethod=syntax

" Add keymappings to move between splits faster
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Toggle line numbers on and of by typing \n
map \n :set invnu<CR>

" Toggle highlighting after a search on and of by typing \h
map \h :nohl<CR>

" Toggle line wrapping  on and off by typing \w
map \w :set invwrap<CR>

" Toggle NERDTree on and off by typing \\
map \\ :NERDTreeToggle<CR>

" Make NERDTree cd to directory when root is changed
let NERDTreeChDirMode=2

" Show NERDTree bookmarks by default.
let NERDTreeShowBookmarks=1

" Quit NERDTree after a file is opened
let NERDTreeQuitOnOpen=1

" Add a $ to the end of a change buffer
set cpoptions+=$

" Allow cursor to move anywhere regardless of the underlying text
set virtualedit=all

" Load Simplenote credentials from .simplenoterc
source ~/.simplenoterc

" Set height of Simplenote list
let g:SimplenoteListHeight=30

" Query and list Simplenotes
map \s :Simplenote -l<CR>

" New Simplenote
map \a :Simplenote -n<CR>

" Tag Simplenote
map \t :Simplenote -t<CR>

" Trash Simplenote
map \d :Simplenote -d<CR>

" Turn off scroll for VimPager to unbreak search
" https://github.com/rkitover/vimpager/issues/30
let vimpager_scrolloff = 0
