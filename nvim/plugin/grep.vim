" use improved search tools if available

let s:rgcmd='--smart-case --glob=!.git --vimgrep'
let s:agcmd='--smart-case --nocolor --nogroup --column'
let s:ackcmd='-H --smart-case --nocolor --nogroup --column'

if executable('rg')
  let &grepprg='rg '.s:rgcmd
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('sift')
  set grepprg=sift
  set grepformat=%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f\ \ %l%m
elseif executable('ag')
  let &grepprg='ag '.s:agcmd
elseif executable('ack-grep')
  let &grepprg='ack-grep '.s:ackcmd
elseif executable('ack')
  let &grepprg='ack '.s:ackcmd
endif

" Make grep silent by launching it in a subshell
" This additionally allows expansions in the arguments
function! Grep(...)
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

" Automatically use the silent grep version
call Cabbrev('grep', 'Grep')
call Cabbrev('gr', 'Grep')
call Cabbrev('lgrep', 'LGrep')
call Cabbrev('lgr', 'LGrep')

" Open the quickfix window automatically
" This only opens the window if there are valid entries
augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

nnoremap <leader>gg :Grep<space>
nnoremap <leader>gw :Grep <cword> . <cr>
