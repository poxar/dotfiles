" Show relative line numbers in active windows, where number is set
if exists('g:loaded_linenumbers') || v:version < 703
  finish
endif
let g:loaded_linenumbers = 1

augroup relativenumber
  au! relativenumber
  au! WinEnter,VimEnter,BufWinEnter * call linenumbers#refresh()
  au! DiffUpdated * call linenumbers#diff()
augroup END

function! linenumbers#refresh()
  for nr in range(1, winnr('$'))
    if l:nr == winnr() && getwinvar(l:nr, '&number')
      call setwinvar(l:nr, '&relativenumber', 1)
    else
      call setwinvar(l:nr, '&relativenumber', 0)
    endif
  endfor
endfunction

function! linenumbers#diff()
  for nr in range(1, winnr('$'))
    if getwinvar(l:nr, '&diff')
      call setwinvar(l:nr, '&number', 0)
      call setwinvar(l:nr, '&relativenumber', 0)
    endif
  endfor
endfunction
