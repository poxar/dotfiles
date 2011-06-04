
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

" Optionen  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALLGEMEIN
set nocompatible		" Vim-Settings und nicht Vi
set autoindent			" always set autoindenting on
set shiftwidth=4		" vier Vorschübe als indent
set showmode			" Modi anzeigen (zb Einfügen)
set showmatch			" Klammern anzeigen/beep
set ruler			" show the cursor position all the time
set nojoinspaces		" Bei J(oin) keine überflüssigen Leerzeichen einfügen
set whichwrap=""		" nicht über zeilenränder »hüpfen«
set nobackup			" don't use a backup file
set showcmd			" display incomplete commands
set incsearch			" do incremental searching
set nohlsearch			" keine highlighting beim suchen...
set wildmenu			" completion-menü
set mouse=a			" Mausunterstützung
set backspace=indent,eol,start	" allow backspacing over everything in insert mode
set ignorecase			" bei der suche nicht zwischen Groß/kleinschreibung unterscheiden
set scrolloff=3			" beim scrollen drei zeilen mehr anzeigen
set modelines=2 	        " Modelines werden nicht interpretiert
set pastetoggle=<F4>		" Paste/nopaste überall mit F4 ändern
set number			" Zeilennummern
set cryptmethod=blowfish	" Verschlüsselungsmethode
" Testing
set undofile			" persistant undo
set undodir=~/.vim/undo		" undo-infos in ~/.vim/undo speichern

" SYNTAX
colorscheme pablo		" Farbschema
filetype plugin indent on	" Enable file type detection.
syntax on			" Syntaxerkennung
" Haskell
:let hs_highlight_delimiters = 1
:let hs_highlight_boolean = 1
:let hs_highlight_types = 1
:let hs_highlight_more_types = 1
:let hs_highlight_debug = 1

" PLUGINS
:runtime! ftplugin/man.vim	" Manfiles in einem neuen Fenster ansehen
:let g:nips_author = 'Philipp Millar'
":let g:SuperTabDefaultCompletionType = "context" " SuperTab soll entscheiden welche completion
":let g:SuperTabContextDefaultCompletionType = "<c-p>" " falls das nicht möglich ist -> keyword-up

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Abkürzungen  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:iabbrev #b /*<Space>**************************************<Space>*
:iabbrev #e **************************************<Space>*/
:iabbrev mfg Mit<Space>freundlichen<Space>Grüßen
:iabbrev phmi Philipp<Space>Millar
:iabbrev ph Philipp
:iabbrev lg Liebe<Space>Grüße
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Mappings {{{ 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't use Ex mode, use Q for formatting
map Q gq
" Cursortasten ignorieren Umbrüche
map <Up> gk
map <Down> gj
" Foldmethod
map <F2> <esc>:set<space>foldmethod=marker<cr>
map <F3> <esc>:set<space>foldmethod=syntax<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Autocommands & Co.  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only do this part when compiled with support for autocommands.
if has("autocmd")

  "ausgelagerte muttrcs erkennen
  au BufReadPost * if getline(1) =~ "#muttrc" |
    \ set filetype=muttrc

  au BufReadPost *
    \ set filetype=wiki
  
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
" Zeuch für Vim-LaTeX
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Rechtschreibung  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ein bisschen Rechtschreibung...
nmap <Esc>A	:set spell<CR>
nmap <Esc>?	z=
nmap <Esc>i	zg
nmap <Esc>q	:set nospell<CR>
set spelllang=de

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

" andere Macros  {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
runtime macros/justify.vim " justify Text mit v _j
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TODO	{{{
" }}}

" vim:set foldmethod=marker:
