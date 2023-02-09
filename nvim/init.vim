
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
set showmatch
set matchpairs+=<:>
let g:matchparen_insert_timeout=10

set number
set relativenumber
set signcolumn=number

set showbreak=↪
set listchars=tab:⇥\ ,trail:·,extends:⇉,precedes:⇇,nbsp:␣
set fillchars=fold:\ ,vert:│
set breakindent
set breakindentopt=sbr

set diffopt+=vertical
set scrolloff=10
set sidescrolloff=5
set linebreak
set splitright
set splitbelow

set shortmess=atToOIc
set lazyredraw
set termguicolors
set guicursor+=a:Cursor
set cursorline
colorscheme badwolf

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
set wildmode=longest:full
set wildignorecase

" Disable mouse support to avoid touchpad accidents
set mouse=

" Mappings {{{1

inoremap <c-f> <c-x><c-f>

nnoremap gg gg0
" nnoremap ' `
" nnoremap ` '

" Allow some typos in omni completion
inoremap <c-x>o <c-x><c-o>
inoremap <c-x>n <c-x><c-o>
inoremap <c-x><c-n> <c-x><c-o>

" Open last/alternate buffer
nnoremap <c-w><leader> <c-^>

" Substitute word under the curser
nnoremap gS :%s/\<<c-r>=expand('<cword>')<cr>\>/

" Source line or selection
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Edit and reload configuration
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>esv :vsplit $MYVIMRC<cr>

" Operate on the directory of the current file
nnoremap <leader>e.  :edit <c-r>=expand("%:p:h") . "/" <cr>
nnoremap <leader>es. :vsplit <c-r>=expand("%:p:h") . "/" <cr>
nnoremap <leader>c.  :lcd <c-r>=expand("%:p:h")<cr>
cabbrev <expr> %% expand('%:p:h')

" Close all temporary windows (quickfix, locationlist, preview)
nnoremap <leader>q :pclose\|cclose\|lclose<cr>

nnoremap <leader>0 :cfirst<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap <leader>j :cnext<cr>
nnoremap ]q :cnext<cr>
nnoremap <leader>k :cprevious<cr>
nnoremap [q :cprevious<cr>

nnoremap <leader>1 :lfirst<cr>
nnoremap [L :lfirst<cr>
nnoremap ]L :llast<cr>
nnoremap <leader>l :lnext<cr>
nnoremap ]l :lnext<cr>
nnoremap <leader>h :lprevious<cr>
nnoremap [l :lprevious<cr>

nnoremap ]a :next<cr>
nnoremap [a :previous<cr>

" Move visual selection around
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Terminal mode
tnoremap <esc> <c-\><c-n>
tnoremap <c-w> <c-\><c-n><c-w>
tnoremap <c-w><c-w> <c-w>
tnoremap <c-w><esc> <esc>
tnoremap <c-w><space> <c-\><c-n><c-^>

augroup terminal_settings
  au! TermOpen,TermEnter * setlocal nonumber|setlocal norelativenumber
  au! BufEnter term://* startinsert
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

" Commands {{{1

" open split terminals
command! -complete=shellcmd -nargs=1 Terminal <mods> split term://<args> | startinsert
nnoremap <a-n> :Terminal $SHELL<cr>
nnoremap <a-m> :vertical Terminal $SHELL<cr>

" Strip trailing whitespace
command! StripWhitespace normal mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" find and show todos
command! -nargs=? Note grep! \[Nn\]\[Oo\]\[Tt\]\[Ee\]: <args> | botright cope
command! -nargs=? Todo grep! TODO:\\|FIXME:\\|XXX: <args> | botright cope
command! -nargs=? Fixme grep! FIXME:\\|XXX: <args> | botright cope

" edit current filetypeplugin
command! Ftedit execute ":edit ". stdpath('config') ."/ftplugin/".&ft.".vim"

" pretty print
command! -range=% JsonPP :<line1>,<line2>!python -m json.tool
command! -range=% HtmlPP :<line1>,<line2>!pandoc --from=html --to=markdown | pandoc --from=markdown --to=html

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

" Execute tests (vim-test)
let test#strategy = "dispatch"
nnoremap mtt :TestNearest<cr>
nnoremap mtf :TestFile<cr>
nnoremap mta :TestSuite<cr>
nnoremap mtl :TestLast<cr>
nnoremap mtg :TestVisit<cr>

" visual undotree
let g:undotree_ShortIndicators = 1
nnoremap yot :UndotreeToggle<cr>

" better :sort
lua require('sort').setup {}
nnoremap <silent> go <cmd>Sort<cr>
vnoremap <silent> go <esc><cmd>Sort<cr>
nnoremap <silent> go" vi"<esc><cmd>Sort<cr>
nnoremap <silent> go' vi'<esc><cmd>Sort<cr>
nnoremap <silent> go( vi(<esc><cmd>Sort<cr>
nnoremap <silent> go) vi)<esc><cmd>Sort<cr>
nnoremap <silent> go[ vi[<esc><cmd>Sort<cr>
nnoremap <silent> go] vi]<esc><cmd>Sort<cr>
nnoremap <silent> go{ vi{<esc><cmd>Sort<cr>
nnoremap <silent> go} vi}<esc><cmd>Sort<cr>
nnoremap <silent> gop vip<esc><cmd>Sort<cr>

" Abbreviations {{{1
iabbrev (C) ©
iabbrev ldis ಠ_ಠ
iabbrev shrg ¯\_(ツ)_/¯
