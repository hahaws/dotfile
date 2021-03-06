
" hahaws vim config
" version 0.2.0

" ====
" Vim-Plug auto install


let vim_plug_installed=0
if has('win32')
    let vim_plug_path=expand('$HOME/vimfiles/autoload/plug.vim')
    let vim_plug_home=expand('$HOME/vimfiles/autoload')
    if !filereadable(vim_plug_path)
        echo "Installing Vim-Plug ..."
        echo ""
    if executable('curl')
                execute '!curl -fLo ' . expand(vim_plug_path) . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
                echo "Done"
    endif
    let vim_plug_installed=1
    endif
endif

if has('unix')
    let vim_plug_path = expand('~/.vim/autoload/plug.vim')
    let vim_plug_home=expand('~/.vim/plugged')
    if !filereadable(vim_plug_path)
        echo "Installing Vim-plug..."
        echo ""
        silent !mkdir -p ~/.vim/autoload
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        let vim_plug_installed = 1
    endif
endif

if vim_plug_installed
    :execute 'source ' . fnameescape(vim_plug_path)
endif

" ====
" vim plug
call plug#begin(vim_plug_home)

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" auto-pair
Plug 'scrooloose/nerdtree'

Plug 'Raimondi/delimitMate'

Plug 'mhinz/vim-startify'

call plug#end()

" ====
" NerdTree
nnoremap dt :NERDTreeToggle<CR>
nnoremap bn :bNext<CR>
autocmd BufEnter * if 0 == len(filter(range(1, winnr('$')), 'empty(getbufvar(winbufnr(v:val), "&bt"))')) | qa! | endif      " 自动退出NERDTree窗口


" ====
" compatible
set nocompatible
set backspace=indent,eol,start

" ====
" general setting
set nu
set cursorline
set signcolumn=yes
highlight! link SignColumn LineNr
set showmatch
set mouse=a
set wildmenu
set ffs=unix,dos,mac
nnoremap q <NOP>

" ====
" indent setting
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set autoindent
set smarttab

" ====
" fold 
set foldmethod=indent
set foldlevel=99


" ====
" statusline setting

function! GetMode()
    let m = mode()
    if m=='n'
        return "NORMAL"
    elseif m=='i'
        return 'INSERT'
    elseif m == 'v'
        return "VISUAL"
    elseif m == 'V'
        return "LINE VISUAL"
    endif
    return m
endfunc

set laststatus=2
set statusline=\ \ %<%f
set statusline+=%w%h%m%r
set statusline+=\ %{getcwd()}
set statusline+=\ [%{&ff}:%{&fenc}:%Y]
set statusline+=%=%-14.(%{GetMode()}\ %l,%c\ \ \ \ %)\ %p%%\ 

" ====
" set list
set ambiwidth=double
set listchars+=tab:<->,eol: 
set listchars=
set listchars+=tab:>-
if strlen(substitute(strtrans(nr2char(160)), ".", "x", "g")) == 1
    execute "set listchars+=eol:" . nr2char(160)
else
    execute "set listchars+=eol:" . nr2char(32)
endif



" ====
" set gvim window size
if has('win32')
    set lines=46 columns=120
endif

" ====
" scroll setting
set scrolloff=3

" ====
" filetype setting
filetype on
filetype plugin on
filetype indent on

" ====
" syntax highlight
syntax enable

" ====
" highlight search
nnoremap df /
set hlsearch
set incsearch
nnoremap q :noh<CR>

" ====
" encoding setting
set encoding=utf-8 fileencodings=utf-8,ucs-bom,cp936 fileencoding=utf-8

" ====
" other setting
source $VIMRUNTIME/delmenu.vim "garbled
source $VIMRUNTIME/menu.vim "garbled
set visualbell t_vb=  "close visual bell
au GuiEnter * set t_vb= "close beep

" ====
" keymap
inoremap <C-o> <Esc>o
nnoremap <C-s> ^
nnoremap <C-e> $

" ====
" Leader key map
nnoremap <Space> <Nop>
let mapleader="\<Space>"
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q


" ====
" Compile And Run File
nnoremap <F5> :call RunFile()<CR>
function! RunFile()
    exec "w"
    if &filetype == 'c'
        if has('win32')
            exec "!gcc % -o %< && %<.exe"
        else
            exec "!gcc % -o %< %% ./%<"
        endif
    elseif &filetype == 'cpp' || &filetype == 'cc'
        if has('win32')
            exec "!g++ % -o %< -std=c++11 -O2 -Wall && %<.exe"
        else
            exec "!g++ % -o %< -std=c++11 -O2 -Wall && ./%<"
        endif
    endif
    exec "redraw!"
endfunc

" ====
" Run File
nnoremap <S-F5> :call Run()<CR><CR>
function! Run()
    exec "w"
    exec "!" . expand("%<") . (".exe")
    exec "redraw!"
endfunc

" ====
" out of bracket

" 定义跳出括号函数，用于跳出括号
func SkipPair()
    if getline('.')[col('.') - 1] == ')' || getline('.')[col('.') - 1] == ']' || getline('.')[col('.') - 1] == '"' || getline('.')[col('.') - 1] == "'" || getline('.')[col('.') - 1] == '}'
        return "\<ESC>la"
    else
        return "\t"
    endif
endfunc
" 将tab键绑定为跳出括号
inoremap <TAB> <c-r>=SkipPair()<CR>


