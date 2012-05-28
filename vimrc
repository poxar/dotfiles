
"
" vimrc
" Maintainer: Philipp Millar <philipp.millar@gmx.de>
"
"

" settings  {{{

set nocompatible               " don't be compatible to vi

" vundle {{{2
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles
Bundle 'gmarik/vundle'

" GitHub
Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-fugitive'
Bundle 'sjl/gundo.vim'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'Shougo/neocomplcache'
Bundle 'scrooloose/nerdtree'
Bundle 'kana/vim-smartinput'
Bundle 'rygwdn/ultisnips'
Bundle 'godlygeek/tabular'
Bundle 'vim-scripts/taglist.vim'
Bundle 'fmoralesc/vim-pad'
" other git
Bundle 'git://gitorious.org/vim-gnupg/vim-gnupg.git'

" testing bundles
Bundle 'tpope/vim-surround'
"}}}2

filetype plugin indent on      " Enable file type detection.
syntax on

set cursorline
set backup                     " use a backup file
set undofile                   " persistent undo
set directory=~/.vim/tmp       " directory to place swap files in
set backupdir=~/.vim/backup    " directory to place backup files in
set undodir=~/.vim/undo        " directory to place undo files in

set viminfo='100,<50,s10,h,n~/.vim/viminfo
                               " save marks for the last 100 files,
                               " save contents of registers up to 50 lines
                               " each, skip registers larger than 10 kbyte
                               " disable the effect of hlsearch,
                               " save the file to ~/.vim/viminfo

set fileformats=unix,dos,mac   " support all three, in this order
set autochdir                  " always switch to the current file directory
set hidden
set modelines=2                " search the first and last two lines for modelines
set pastetoggle=<F4>
set clipboard=unnamed          " copy to system clipboard

set cryptmethod=blowfish

set shiftwidth=4               " use 4 blanks as indent
set autoindent                 " always set autoindenting on
set smarttab                   " insert shiftwidth at beginning of line
set nojoinspaces               " J(oin) doesn't add useless blanks
set whichwrap=""               " don't jump over linebounds
set backspace=indent,eol,start " allow backspacing over everything in insert mode

set ignorecase                 " search is case insensitive
set smartcase                  " search is case sensitive, when upper-case letters are used
set incsearch                  " do incremental searching
set hlsearch                   " highlighting for searches, deactivate with <F5> (until next search)

set title                      " show title in console title bar
set laststatus=2               " always show the status line
set ruler                      " show the cursor position all the time
set relativenumber             " show relative line numbers
set showmode                   " show the mode we're in
set showmatch                  " show matching parentheses
set showcmd                    " display incomplete commands
set listchars=tab:>-,trail:-   " show tabs and trailing spaces when list is set
set scrolloff=3                " show 3 extra lines when scrolling
set lazyredraw                 " do not redraw while running macros
set wildmenu                   " completion-menu
set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png

set path=~/code/**
"}}}

" plugins {{{
" load colorscheme
let g:solarized_underline=0
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
let g:solarized_diffmode="high"
let g:solarized_hitrail=1
if has('gui_running')
    set background=light
else
    set background=dark
endif
colorscheme solarized

" Man files
runtime ftplugin/man.vim

" improved completion
let g:neocomplcache_enable_at_startup = 1

" SnipMate
let g:snips_author = 'Philipp Millar'

" Taglist
let Tlist_Compact_Format = 1           " show small menu
let Tlist_Ctags_Cmd = '/usr/bin/ctags' " location of ctags
let Tlist_Exit_OnlyWindow = 1          " if you are the last, kill yourself
let Tlist_File_Fold_Auto_Close = 0     " fold closed other trees

" vim-pad
let g:pad_dir = '~/.pim/notes'
let g:pad_window_height = 12
"}}}

" syntax {{{
" haskell
let g:hs_highlight_delimiters = 1
let g:hs_highlight_boolean = 1
let g:hs_highlight_types = 1
let g:hs_highlight_more_types = 1
let g:hs_highlight_debug = 1
" }}}

" mappings {{{
" Don't use Ex mode, use Q for formatting
vmap Q gq
nmap Q gqap
" Y defaults to doing yy due to Vi compatability, but this makes it consistent with D and C
nmap Y y$
" use cursor keys to jump over wrapped lines
map <Up> gk
map <Down> gj
" simplify window-management
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" foldmethod
nmap <F2> <esc>:set<space>foldmethod=marker<cr>
nmap <F3> <esc>:set<space>foldmethod=syntax<cr>
"<F4> is pastetoggle
" stop highlighting until next search
nmap <F5> <esc>:nohlsearch<cr>
" show/hide tabs and trailing spaces
nmap <F6> <esc>:set<space>list!<cr>
" taglist
nmap <F8> <esc>:TlistToggle<cr>
" GUndo
nmap <F9> <esc>:GundoToggle<cr>
" NERDTree
nmap <F10> <esc>:NERDTreeToggle<cr>
" enclose visual block with (, ", ', etc
vnoremap <leader>1 <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>2 <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>3 <esc>`>a}<esc>`<i{<esc>
vnoremap <leader>4 <esc>`>a><esc>`<i<<esc>
vnoremap <leader>q <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>e <esc>`>a"<esc>`<i"<esc>
" swap ' and ` so 'a goes to line and column marked with ma
nnoremap ' `
nnoremap ` '
" cope
nnoremap <leader>co :botright cope<cr>
nnoremap <leader>cn :cn<cr>
nnoremap <leader>cp :cp<cr>
" location list
nnoremap <leader>lo :lopen<cr>
nnoremap <leader>ln :lnext<cr>
nnoremap <leader>lp :lprevious<cr>
" remind
nnoremap <leader>tt <esc>oREM<Space><+Datum+><Space>AT<Space><+Uhrzeit+><Space>DURATION<Space><+Dauer+><Space>MSG<Space>%"<+Terminbeschreibung+><Space>%"<esc>0
nnoremap <leader>ut <esc>oREM<Space><+Datum+><Space>MSG<Space>%"<+Terminbeschreibung+>%"<esc>0
" sudo
cmap w!! w !sudo tee % >/dev/null
"}}}

" autocommands  {{{
if has("autocmd")
    " all text-files are 80 chars wide by default
    autocmd FileType text setlocal textwidth=80
    " load skel files
    autocmd! BufNewFile * silent! 0r ~/.vim/skel/tmpl.%:e
endif
" }}}

" commands and functions  {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" spell-check  {{{2
nmap <Esc>A     :set spell<CR>
nmap <Esc>?     z=
nmap <Esc>i     zg
nmap <Esc>q     :set nospell<CR>
set spelllang=de

" function to change the spell-language
let spellst = ["de", "en"]
let langcnt = 0

function!  Sel_lang()
        let g:langcnt = (g:langcnt+1) % len(g:spellst)
        let lang = g:spellst[g:langcnt]
        echo "Sprache " . lang . " gewählt"
        exe "set spelllang=" . lang
endfunction

nmap <Esc>l     :call Sel_lang()<CR>
" }}}2
" strip whitespace {{{2
function! StripWhitespace ()
        exec ':%s/ \+$//gc'
endfunction

map ,s :call StripWhitespace ()<CR>
" }}}2
" change linenumber mode {{{2
function! g:ToggleNumberMode()
	if(&rnu == 1)
		set nu
	else
		set rnu
	endif
endfunc
 
nnoremap <f12> :call g:ToggleNumberMode()<cr>
" }}}2
"}}}


" vim:set sw=4 foldmethod=marker ft=vim:
