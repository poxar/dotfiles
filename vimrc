
"
" vimrc
" Maintainer:	Philipp Millar <philipp.millar@gmx.de>
"

" evim {{{
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif
"}}}

" options  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible		" don't be compatible to vi
set autoindent			" always set autoindenting on
set shiftwidth=4
set showmode
set showmatch			" show matching parentheses
set ruler			" show the cursor position all the time
set nojoinspaces		" J(oin) doesn't add useless blanks
set whichwrap=""		" don't jump over linebounds
set nobackup			" don't use a backup file
set showcmd			" display incomplete commands
set incsearch			" do incremental searching
set nohlsearch			" no highlighting for searches
set wildmenu			" completion-menu
set mouse=a			" use the mouse
set backspace=indent,eol,start	" allow backspacing over everything in insert mode
set ignorecase			" search is case insensitive
set scrolloff=3			" show 3 extra lines when scrolling
set modelines=2 	        " search the first and last two lines for modelines
set pastetoggle=<F4>
set number
set cryptmethod=blowfish
" Testing
set undofile			" persistent undo
set undodir=~/.vim/undo		" undo-infos are saved in ~/.vim/undo

" SYNTAX
colorscheme pablo
filetype plugin indent on	" Enable file type detection.
syntax on
" Haskell
:let hs_highlight_delimiters = 1
:let hs_highlight_boolean = 1
:let hs_highlight_types = 1
:let hs_highlight_more_types = 1
:let hs_highlight_debug = 1

" PLUGINS
:runtime! ftplugin/man.vim	" plugin for showing manfiles
:let g:nips_author = 'Philipp Millar'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" abbreviations  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" c
:iabbrev #b /*<Space>**************************************<Space>*
:iabbrev #e **************************************<Space>*/
" mail
:iabbrev mfg Mit<Space>freundlichen<Space>Grüßen
:iabbrev phmi Philipp<Space>Millar
:iabbrev lg Liebe<Space>Grüße
:iabbrev ph Philipp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" mappings {{{ 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't use Ex mode, use Q for formatting
map Q gq
" use cursor keys not linewise
map <Up> gk
map <Down> gj
" foldmethod
map <F2> <esc>:set<space>foldmethod=marker<cr>
map <F3> <esc>:set<space>foldmethod=syntax<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" autocommands  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only do this part when compiled with support for autocommands.
if has("autocmd")

  "obsolete
  "au BufReadPost * if getline(1) =~ "#muttrc" |
  "  \ set filetype=muttrc

  "au BufReadPost *
  "  \ set filetype=wiki
  
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" LaTeX  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" spell-check  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" stuff  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
runtime macros/justify.vim " justify text with v _j
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TODO	{{{
" }}}

" vim:set sw=4 foldmethod=marker:
