" use improved search tools if available

let s:rgcmd='--smart-case --vimgrep'
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

command! -nargs=+ -complete=file Grep silent grep! <args> | cw
nnoremap <leader>gg :Grep<space>
