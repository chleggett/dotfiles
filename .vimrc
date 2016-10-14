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
Plugin 'bling/vim-bufferline'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'shime/vim-livedown'
Plugin 'neilagabriel/vim-geeknote'
Plugin 'valloric/youcompleteme'
Plugin 'raimondi/delimitmate'
Plugin 'tpope/vim-surround'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on

" Main Config """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set backspace=indent,eol,start   " Make backspace work like it does most other apps
set shiftwidth=4                 " Indent 4 columns
set relativenumber		 " Enable relative line numbering
set number                       " Set current line to actual line number
set textwidth=80                 " Wrap after 80 columns
set nowrap                       " Do not wrap long lines by default
set cpoptions+=$                 " Add a $ to the end of a change buffer
set incsearch                    " Incremental search as you type characters
set hlsearch                     " Highlight search results
set cursorline                   " Highlight the current line
set cursorcolumn                 " Highlight the current line
set hidden                       " Use hidden buffers by default
set laststatus=2                 " Set laststatus to always to show status bar
set virtualedit=all              " Allow cursor to move anywhere regardless of the underlying text
set foldmethod=syntax            " Auto fold based on syntax
set splitbelow                   " Open horizontal splits below
set splitright                   " Open vertical splits to the right
set listchars=tab:▸\ ,eol:¬      " Use 'fancy' invisible characters
set clipboard=unnamed		 " Use system clipboard

" Colorscheme """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax enable
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

" Shortcuts and Keybindings """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader=" "                        	" Change the <Leader> key
map <Leader>n    :set invnu invrnu<CR>   	" Toggle relative line numbers by typing <Leader>n
map <Leader>h    :nohl<CR>               	" Disable highlighting after a search
map <Leader>sw   :StripWhitespace<CR>    	" Strip trailing whitespace
map <Leader>l    :set list!<CR>          	" Toggle invisible characters
map <Leader>p    :set invpaste<CR>       	" Toggle paste mode.
map <Leader>w    :set invwrap<CR>        	" Toggle wrap mode.

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

" vim-airline (with bufferline extension) """"""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:bufferline_echo=0  " Hide the default bufferline and use airline's instead

" NERDTree """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <Leader>nt  :NERDTreeToggle<CR> " Toggle NERDTree on and off by typing <Leader>\
let NERDTreeChDirMode=2             " Make NERDTree cd to directory when root is changed
let NERDTreeShowBookmarks=1         " Show NERDTree bookmarks by default.

" vim-gitgutter """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <Leader>g  :GitGutterSignsToggle<CR>

" livedown """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>ld :LivedownToggle<CR> " Toggle Livedown Preview

" Geeknote """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <Leader>gn :Geeknote<cr>

" delimitMate """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let delimitMateAutoClose=1

" YouCompleteMe """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_autoclose_preview_window_after_completion=1
