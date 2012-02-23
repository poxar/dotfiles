
"
" vimrc
" Maintainer: Philipp Millar <philipp.millar@gmx.de>
"
" Plugins:
" 	* latexsuite
" 	* snipmate
" 	* taglist
" 	* easytags
" 	* gnupg
"

" settings  {{{
filetype plugin indent on	" Enable file type detection.
syntax on

" load colorscheme
colorscheme jellybeans
set cursorline

set nocompatible		" don't be compatible to vi
set backup			" use a backup file
set undofile			" persistent undo
set directory=~/.vim/tmp	" directory to place swap files in
set backupdir=~/.vim/backup	" directory to place backup files in
set undodir=~/.vim/undo		" directory to place undo files in

set viminfo='100,<50,s10,h,n~/.vim/viminfo
				" save marks for the last 100 files,
				" save contents of registers up to 50 lines
				" each, skip registers larger than 10 kbyte
				" disable the effect of hlsearch,
				" save the file to ~/.vim/viminfo

set fileformats=unix,dos,mac	" support all three, in this order
set autochdir			" always switch to the current file directory
set modelines=2 	        " search the first and last two lines for modelines
set pastetoggle=<F4>
set cryptmethod=blowfish

set mouse=a			" use the mouse
set shiftwidth=4		" use 4 blanks as indent
set autoindent			" always set autoindenting on
set smarttab			" insert shiftwidth at beginning of line
set nojoinspaces		" J(oin) doesn't add useless blanks
set whichwrap=""		" don't jump over linebounds
set backspace=indent,eol,start	" allow backspacing over everything in insert mode

set ignorecase			" search is case insensitive
set smartcase			" search is case sensitive, when upper-case letters are used
set incsearch			" do incremental searching
set hlsearch			" highlighting for searches, deactivate with <F5> (until next search)

set title			" show title in console title bar
set laststatus=2		" always show the status line
set ruler			" show the cursor position all the time
set number			" show line numbers
set showmode			" show the mode we're in
set showmatch			" show matching parentheses
set showcmd			" display incomplete commands
set listchars=tab:>-,trail:-	" show tabs and trailing spaces when list is set
set scrolloff=3			" show 3 extra lines when scrolling
set lazyredraw			" do not redraw while running macros
set wildmenu			" completion-menu
set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png
"}}}

" plugins {{{
runtime macros/justify.vim	" justify text with v _j
runtime ftplugin/man.vim	" plugin for showing manfiles
let g:snips_author = 'Philipp Millar'

" taglist
let Tlist_Compact_Format = 1	" show small menu
let Tlist_Ctags_Cmd = 'ctags'	" location of ctags
let Tlist_Exit_OnlyWindow = 1	" if you are the last, kill yourself
let Tlist_File_Fold_Auto_Close = 0 " fold closed other trees

" LaTeX
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_CompileRule_pdf='pdflatex --interaction=nonstopmode $*'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'

" EasyTags
let g:easytags_file = '~/.vim/tags'
"}}}

" syntax {{{
" haskell
let hs_highlight_delimiters = 1
let hs_highlight_boolean = 1
let hs_highlight_types = 1
let hs_highlight_more_types = 1
let hs_highlight_debug = 1
" }}}

" abbreviations  {{{
" c
iabbrev #b /*<Space>**************************************<Space>*
iabbrev #e **************************************<Space>*/
" zsh
iabbrev #z #!/bin/zsh<cr>
" sh
iabbrev #s #!/bin/sh<cr>
" python
iabbrev #p #!/usr/bin/env<Space>python<cr>#<Space>-*-<Space>coding:<Space>utf-8<Space>-*-
" mail
iabbrev mfg Mit<Space>freundlichen<Space>Grüßen
iabbrev phmi Philipp<Space>Millar
iabbrev lg Liebe<Space>Grüße
iabbrev ph Philipp
" }}}

" mappings {{{
" Don't use Ex mode, use Q for formatting
map Q gq
" use cursor keys to jump over wrapped lines
map <Up> gk
map <Down> gj
" foldmethod
map <F2> <esc>:set<space>foldmethod=marker<cr>
map <F3> <esc>:set<space>foldmethod=syntax<cr>
"<F4> is pastetoggle
" stop highlighting until next search
map <F5> <esc>:nohlsearch<cr>
" show/hide tabs and trailing spaces
map <F6> <esc>:set<space>list!<cr>
" taglist
map <F8> <esc>:TlistToggle<cr>
" enclose visual block with (, ", ', etc
vnoremap <leader>1 <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>2 <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>3 <esc>`>a}<esc>`<i{<esc>
vnoremap <leader>4 <esc>`>a><esc>`<i<<esc>
vnoremap <leader>q <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>e <esc>`>a"<esc>`<i"<esc>
" python
nnoremap <leader>" <esc>o"""<cr><cr>"""<esc>ki
vnoremap <leader>" <esc>`>o"""<esc>`<O"""<esc>
" cope
nnoremap <leader>co :botright cope<cr>
nnoremap <leader>n :cn<cr>
nnoremap <leader>p :cp<cr>
" location list
nnoremap <leader>lo :lopen<cr>
nnoremap <leader>ln :lnext<cr>
nnoremap <leader>lp :lprevious<cr>
" remind
nnoremap <leader>tt <esc>oREM<Space><+Datum+><Space>AT<Space><+Uhrzeit+><Space>DURATION<Space><+Dauer+><Space>MSG<Space>%"<+Terminbeschreibung+><Space>%"<esc>0
nnoremap <leader>ut <esc>oREM<Space><+Datum+><Space>MSG<Space>%"<+Terminbeschreibung+>%"<esc>0
"}}}

" autocommands  {{{
" all text-files are 80 chars wide by default
autocmd FileType text setlocal textwidth=80
autocmd! BufNewFile * silent! 0r ~/.vim/skel/tmpl.%:e
" }}}

" commands  {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis
"}}}

" spell-check  {{{
nmap <Esc>A	:set spell<CR>
nmap <Esc>?	z=
nmap <Esc>i	zg
nmap <Esc>q	:set nospell<CR>
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

nmap <Esc>l	:call Sel_lang()<CR>
" }}}

function! StripWhitespace ()
        exec ':%s/ \+$//gc'
endfunction

map ,s :call StripWhitespace ()<CR>

" vim:set sw=4 foldmethod=marker ft=vim:
