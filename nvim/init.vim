
"
" init.vim
" Maintainer: Philipp Millar <philipp.millar@poxar.net>
"

" Settings {{{1
set undofile
set nomodeline

set virtualedit=block
set clipboard+=unnamedplus

let g:mapleader      = ' '
let g:maplocalleader = '\\'

" Text formatting
set textwidth=100
set formatoptions=qcrn2j
set shiftround
set expandtab
set shiftwidth=2

" Search and replace
set ignorecase
set smartcase
set gdefault
set tagcase=followscs

" Display
set noshowmode
set matchpairs+=<:>
set pumheight=10

" Automatically Rebalance windows
augroup balance_windows
  au! VimResized * :wincmd =
augroup END

set number
set relativenumber
set signcolumn=number

set linebreak
set showbreak=↪
set listchars=tab:⇥\ ,trail:·,extends:⇉,precedes:⇇,nbsp:␣
set fillchars=fold:\ ,vert:│
set breakindent
set breakindentopt=sbr

if has("nvim-0.9")
  set diffopt+=vertical,linematch:60
else
  set diffopt+=vertical
endif

set scrolloff=1
set sidescrolloff=5
set splitright
set splitbelow

set shortmess=tToOc
set notimeout
set termguicolors
set guicursor+=a:Cursor
set cursorline
colorscheme poxar

" Highlight git conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Highlight yanked area
if has('nvim-0.5.0')
  au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=250, on_visual=true}
endif

" Spelling
set spelllang=en_gb,de_20

" Completion
set omnifunc=syntaxcomplete#Complete
set wildoptions=pum,tagfile
set wildmode=lastused:longest:full
set wildignorecase

" Enable mouse in normal and visual modes and when viewing help files
set mouse=nvh

" Mappings {{{1

inoremap <c-f> <c-x><c-f>

nnoremap gg gg0
nnoremap gh 0
nnoremap gl $
nnoremap gs _

" Simpler redo
nnoremap U <c-r>

" Jump to exact mark position by default
nnoremap ' `
nnoremap ` '

" Allow some typos in omni completion
inoremap <c-x>o <c-x><c-o>
inoremap <c-x>n <c-x><c-o>
inoremap <c-x><c-n> <c-x><c-o>

" Quicksave
inoremap <c-s> <c-\><c-o>:w<cr>
nnoremap <c-s> :w<cr>

" Open last/alternate buffer
nnoremap <c-w><leader> <c-^>

" Switch to last window
nnoremap <c-w>; <c-w>p

" Substitute word under the curser
nnoremap gS :%s/\<<c-r>=expand('<cword>')<cr>\>/

" Source line or selection
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Edit and reload configuration
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :edit $MYVIMRC<cr>

" Quickly edit notes inbox
nnoremap <leader>en :edit ~/Notes/Eingang.md<cr>
nnoremap <leader>cn :lcd ~/Notes<cr>

" Operate on the directory of the current file
nnoremap <leader>e.  :edit <c-r>=expand("%:p:h") . "/" <cr>
cabbrev <expr> %% expand('%:p:h')

" Close all temporary windows (quickfix, locationlist, preview)
nnoremap <leader>q :pclose\|cclose\|lclose<cr>

nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap ]q :cnext<cr>
nnoremap [q :cprevious<cr>

nnoremap [L :lfirst<cr>
nnoremap ]L :llast<cr>
nnoremap ]l :lnext<cr>
nnoremap [l :lprevious<cr>

nnoremap ]a :next<cr>
nnoremap [a :previous<cr>

" Terminal mode
tnoremap <esc> <c-\><c-n>
nnoremap <leader>ts :split<cr>:terminal<cr>:startinsert<cr>
nnoremap <leader>tv :vsplit<cr>:terminal<cr>:startinsert<cr>

augroup terminal_settings
  au! TermOpen,TermEnter * setlocal nonumber|setlocal norelativenumber
augroup END

" Readline mappings for command line mode
cnoremap <c-a> <home>
cnoremap <c-x><c-a> <c-a>

" toggles
function! s:toggle_map(letter, option) abort
  let set_on = '"setlocal '.a:option.'"'
  let set_off = '"setlocal no'.a:option.'"'
  exe 'nnoremap yo'.a:letter.' :<c-u><c-r>=&'.a:option.' ? '.set_off.' : '.set_on.'<cr><cr>'
endfunction

call <sid>toggle_map('l', 'list')
call <sid>toggle_map('n', 'number')
call <sid>toggle_map('r', 'relativenumber')
call <sid>toggle_map('s', 'spell')

nnoremap yod :<c-u><c-r>=&diff ? "diffoff" : "diffthis"<cr><cr>

" show highlighting group under cursor
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
nnoremap <leader>cc :call SynGroup()<cr>

" Commands {{{1

" Strip trailing whitespace
command! StripWhitespace normal mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" find and show todos
command! -nargs=? Note grep! \[Nn\]\[Oo\]\[Tt\]\[Ee\]: <args> | botright cope
command! -nargs=? Todo grep! TODO:\\|FIXME:\\|XXX: <args> | botright cope
command! -nargs=? Fixme grep! FIXME:\\|XXX: <args> | botright cope

" edit current filetypeplugin
command! Ftedit execute ":edit ". stdpath('config') ."/ftplugin/".&ft.".vim"
nnoremap <leader>ef :Ftedit<cr>

" pretty print
command! -range=% JsonPP :<line1>,<line2>!python -m json.tool
command! -range=% HtmlPP :<line1>,<line2>!pandoc --from=html --to=markdown | pandoc --from=markdown --to=html
command! -range=% XmlPP :<line1>,<line2>!xmllint --format -

" Plugins {{{1

let $MANWIDTH = 80
let g:man_hardwrap = 1
let g:termdebug_wide = 1

" dirvish, a replacement for netrw
let g:loaded_netrwPlugin = 1
let g:dirvish_mode = ':silent keeppatterns g@\v/\.[^\/]+/?$@d _'

" open git status (tpope/fugitive)
nnoremap <leader>gs :Git<cr>
nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gc :Git commit<cr>
nnoremap <leader>g<space> :Git<space>

" snippets
let g:snips_author = "Philipp Millar"
let g:snips_email = "philipp.millar@poxar.net"

" operate on tables (godlygeek/tabular)
nnoremap g= :Tabularize /
vnoremap g= :Tabularize /
nnoremap g\: :Tabularize /:\zs<cr>
vnoremap g\: :Tabularize /:\zs<cr>
nnoremap g\, :Tabularize /,\zs<cr>
vnoremap g\, :Tabularize /,\zs<cr>
nnoremap g\= :Tabularize /=<cr>
vnoremap g\= :Tabularize /=<cr>

" Visual undotree
let g:undotree_ShortIndicators = 1
nnoremap yot :UndotreeToggle<cr>

" Better :sort
lua require('sort').setup {}
nnoremap <silent> go <cmd>Sort<cr>
vnoremap <silent> go <esc><cmd>Sort<cr>
nnoremap <silent> go" vi"<esc><cmd>Sort<cr>
nnoremap <silent> go' vi'<esc><cmd>Sort<cr>
nnoremap <silent> go( vi(<esc><cmd>Sort<cr>
nnoremap <silent> gob vib<esc><cmd>Sort<cr>
nnoremap <silent> go) vi)<esc><cmd>Sort<cr>
nnoremap <silent> go[ vi[<esc><cmd>Sort<cr>
nnoremap <silent> go] vi]<esc><cmd>Sort<cr>
nnoremap <silent> go{ vi{<esc><cmd>Sort<cr>
nnoremap <silent> goB viB<esc><cmd>Sort<cr>
nnoremap <silent> go} vi}<esc><cmd>Sort<cr>
nnoremap <silent> gop vip<esc><cmd>Sort<cr>

" Automatically run linters
let g:ale_disable_lsp = 1
let g:ale_use_neovim_diagnostics_api = 1
let g:ale_virtualtext_cursor = 'disabled'

" Abbreviations {{{1
iabbrev (C) ©
iabbrev ldis ಠ_ಠ
iabbrev shrg ¯\_(ツ)_/¯

cabbrev dg diffget
cabbrev dp diffput
