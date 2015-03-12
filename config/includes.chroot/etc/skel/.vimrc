" General options
" ---------------

set nocompatible                  " duh

set shiftwidth=4                  " four spaces seems like a good default
set expandtab                     " use spaces for tabs, please
set smarttab                      " TAB at start of line = indetation
set smartindent                   " add indentation for code
set autoindent                    " continue indentation

set nojoinspaces                  " When joining lines, use a single space after
                                  " periods.

set incsearch                     " perform search as you type
set nohlsearch                    " don't highlight search results
set ignorecase                    " ignore case when searching...
set smartcase                     " ...unless a capital letter was typed

set autoread                      " reload changed files when focus returns
set modeline                      " enable modelines

set showmatch                     " show matching brace when closed
set ruler                         " show line and column number in statusbar
set showcmd                       " display commands in progress at the bottom


" Syntax and file types
" ---------------------

syntax on
filetype plugin indent on
