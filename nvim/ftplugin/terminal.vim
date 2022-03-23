setlocal nonumber
setlocal norelativenumber

augroup terminal_insert
  au! BufEnter term://* startinsert
augroup END
