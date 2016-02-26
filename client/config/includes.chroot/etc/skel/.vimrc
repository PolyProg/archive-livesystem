" General options
" ---------------

set number

set nocompatible                  " duh

set smartindent                   " add indentation for code
set autoindent                    " continue indentation
set backspace=indent,eol,start    " from vim-sensible
set complete-=i                   " from vim-sensible

set nojoinspaces                  " When joining lines, use a single space after
                                  " periods.

set incsearch                     " perform search as you type
set nohlsearch                    " don't highlight search results
set ignorecase                    " ignore case when searching...
set smartcase                     " ...unless a capital letter was typed

set autoread                      " reload changed files when focus returns
set modeline                      " enable modelines

set laststatus=2                  " from vim-sensible
set showmatch                     " show matching brace when closed
set ruler                         " show line and column number in statusbar
set showcmd                       " display commands in progress at the bottom
set wildmenu                      " from vim-sensible

set nrformats-=octal              " from vim-sensible

set ttimeout                      " from vim-sensible
set ttimeoutlen=100               " from vim-sensible


" Syntax and file types
" ---------------------

syntax on
filetype plugin indent on
colorescheme elflord


" Some other commands from vim-sensible
" -------------------------------------

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$'
  set shell=/bin/bash
endif

set fileformats+=mac

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

inoremap <C-U> <C-G>u<C-U>

" vim:set ft=vim et sw=2:
