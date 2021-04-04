" Charles H. Leggett's .vimrc
" There are many like it, but this one is mine.

"""" Vundle Config """"
set nocompatible
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Add plugins
Plugin 'airblade/vim-gitgutter'
"Plugin 'bling/vim-bufferline'
Plugin 'morhetz/gruvbox'
Plugin 'ntpeters/vim-better-whitespace'
"Plugin 'preservim/nerdtree'
"Plugin 'raimondi/delimitmate'
Plugin 'rkitover/vimpager'
"Plugin 'shime/vim-livedown'
"Plugin 'tpope/vim-fugitive'
"Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-scripts/scrollfix'
"Plugin 'vim-syntastic/syntastic'
"Plugin 'ycm-core/youcompleteme'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on


"""" Main Config """"
set backspace=indent,eol,start   " Make backspace work like it does most other apps
set clipboard=unnamed            " Use system clipboard
set cpoptions+=$                 " Add a $ to the end of a change buffer
set cursorcolumn                 " Highlight the current line
set cursorline                   " Highlight the current line
set foldmethod=syntax            " Auto fold based on syntax
set hidden                       " Use hidden buffers by default
set hlsearch                     " Highlight search results
set ignorecase                   " Case of normal letters is ignored in search
set incsearch                    " Incremental search as you type characters
set laststatus=2                 " Set laststatus to always to show status bar
set lazyredraw                   " Don’t update screen during macro and script execution
set list                         " idk except that it's needed for the next line
set listchars=tab:>-             " tabs suck
set mouse=a                      " Mouse support
set noshowmode                   " Let airline handle this
set nowrap                       " Do not wrap long lines by default
set number                       " Set current line to actual line number
set relativenumber               " Enable relative line numbering
set tabstop=4                    " Tab is 4 spaces
set shiftwidth=4                 " Indent 4 columns
set smartcase                    " Ignore case when the pattern contains only lowercase
set splitbelow                   " Open horizontal splits below
set splitright                   " Open vertical splits to the right
set textwidth=80                 " Wrap after 80 columns
set virtualedit=all              " Allow cursor to move anywhere regardless of the underlying text

autocmd FileType markdown setlocal spell

"""" Colorscheme """"
syntax enable
set background=dark
let g:gruvbox_sign_column='dark0'
colorscheme gruvbox


"""" Shortcuts and Keybindings """"
nmap <space> <leader>
" let mapleader=" "                         " Use space as the leader
" noremap <Space> <Nop>                     " Prevent space from also moving when used as leader

map <Leader>n    :set invnu invrnu<CR>      " Toggle relative line numbers by typing <Leader>n
map <Leader>h    :nohl<CR>                  " Disable highlighting after a search
map <Leader>sw   :StripWhitespace<CR>       " Strip trailing whitespace
map <Leader>l    :set list!<CR>             " Toggle invisible characters
map <Leader>p    :set invpaste<CR>          " Toggle paste mode.
map <Leader>w    :set invwrap<CR>           " Toggle wrap mode.

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


"""" VimPager """"
" Turn off scroll for VimPager to unbreak search (https://github.com/rkitover/vimpager/issues/30)
let g:vimpager = {}
let g:less     = {}
let g:less.enabled=0


"""" Plugin 'airblade/vim-gitgutter' """"
map <Leader>g  :GitGutterSignsToggle<CR>


"""" Plugin 'bling/vim-airline' """"
let g:bufferline_echo=0  " Hide the default bufferline and use airline's instead


"""" Plugin 'vim-scripts/scrollfix' """"
let g:scrollfix=25
let g:fixeof=0


"""" NERDTree """"
map <Leader>nt  :NERDTreeToggle<CR> " Toggle NERDTree on and off by typing <Leader>\
let NERDTreeChDirMode=2             " Make NERDTree cd to directory when root is changed
let NERDTreeShowBookmarks=1         " Show NERDTree bookmarks by default.


"""" Plugin 'shime/vim-livedown' """"
map <Leader>ld :LivedownToggle<CR> " Toggle Livedown Preview


"""" delimitMate """"
let delimitMateAutoClose=1

"""" YouCompleteMe """"
let g:ycm_autoclose_preview_window_after_completion=1


