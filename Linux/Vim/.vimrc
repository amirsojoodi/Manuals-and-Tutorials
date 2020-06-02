set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugin 'Valloric/YouCompleteMe'

Plugin 'JamshedVesuna/vim-markdown-preview'

Plugin 'godlygeek/tabular'

Plugin 'plasticboy/vim-markdown'

" All of your Plugins must be added before the following line
Plugin 'Valloric/YouCompleteMe'

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
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=4    " Indents will have a width of 4

set softtabstop=4   " Sets the number of columns for a TAB

set noexpandtab       " Expand TABs to spaces
set smarttab
set smartindent
set cindent
set autoindent
set showmatch
set history=1000
set undolevels=1000
set visualbell
set noerrorbells

set foldmethod=indent
set foldlevel=99
set number
set tags=tags		" This is to use ctags

let vim_markdown_preview_github=1

" clang-format can be found at this address:
" https://github.com/rhysd/vim-clang-format
"
" follow instruction to install clang-format 
" and then uncomment these lines:
" let g:clang_format#code_style = 'google'
" let g:clang_format#style_options = {
"     \ 'TabWidth' : 4,
"     \ "ColumnLimit' : 100,
"     \ 'IndentWidth' : 4,
"     \ 'IndentCaseLabels' : 'true',
"     \ 'NamespaceIndentation' : 'All',
"     \ 'Standard' : 'Auto'}

