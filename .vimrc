"""""" .vimrc file """""
" Use vim settings
" PUT THIS FIRST
set nocompatible
"filetype plugin on
filetype off
set encoding=utf-8          " Default UTF-8 support

" Stuff for vimLatex
set grepprg=grep\ -nH\ $*
"let g:tex_flavor = "latex"
"let g:Tex_DefaultTargetFormat="pdf"
"let g:Tex_MultipleCompileFormats="pdf"

" enable syntax highlighting
syntax enable

" enable folding (wrapping text)
set foldmethod=indent
set foldlevel=99
" enable folding via space in addition to za
nnoremap <space> za

" For arduino syntax!
autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino

" For Pathogen
" Remove the leading double quote to uncomment
execute pathogen#infect()
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" hide buffers without having to write on undo changes first
set hidden

set wrap                        " do wrap lines
set backspace=indent,eol,start
                                " allow backspacing over everything in insert mode
" split panes nav
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-W>

" indenting options
set shiftwidth=4                " number of spaces to use for autoindenting
set tabstop=4                   " a tab is four spaces
set autoindent                  " always set autoindenting on
set cindent                     " indents for C like files
set copyindent                  " copy the previous indentation on autoindenting
set smarttab                    " insert tabs on the start of a line according to
                                "    shiftwidth, not tabstop
set expandtab                   " Expand tabs into spaces
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'

set number                      " always show line numbers
set relativenumber              " combined with set number set hybrid-relative-number mode
set showmatch                   " set show matching parenthesis
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
                                "    case-sensitive otherwise
set scrolloff=4                 " keep 4 lines off the edges of the screen when scrolling
set virtualedit=all             " allow the cursor to go in to \"invalid\" places

set hlsearch                    " highlight search terms
set incsearch                   " show search matches as you type

set pastetoggle=<F2>            " when in insert mode, press <F2> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented
"set mouse=a                     " enable using the mouse if terminal emulator
                                "    supports it (xterm does and urxvt)
set fileformats="unix,dos,mac"
set formatoptions+=1            " When wrapping paragraphs, don't end lines


set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                       " change the terminal's title
set ls=2                         "Show filename at bottom

" Set Colorscheme from https://github.com/flazz/vim-colorschemes
colorscheme solarized8_dark

" auto PEP8 python indentation mode
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \| set softtabstop=4
    \| set shiftwidth=4
    \| set textwidth=79
    \| set expandtab
    \| set autoindent
    \| set fileformat=unix

" Full stack dev mode
au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2
    \| set softtabstop=2
    \| set shiftwidth=2

" Mark extraneous whitespace in py files
highlight BadWhitespace ctermbg=red guibg=darkred      
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /\s\+$/


