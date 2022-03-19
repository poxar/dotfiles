" colorcolumn and cursorline
" This maps yoC to toggle the colorcolumn, but shows it only in the current
" buffer. Furthermore the cursorline is shown in the current buffer.
" toggle colorcolumn at textwidth + 1

function! s:ToggleColorColumn()
  if exists('b:my_cc')
    setlocal colorcolumn=
    setlocal colorcolumn?
    unlet b:my_cc
  else
    setlocal colorcolumn=+1
    setlocal colorcolumn?
    let b:my_cc = 1
  endif
endfunc

nnoremap yoC :call <SID>ToggleColorColumn()<cr>
