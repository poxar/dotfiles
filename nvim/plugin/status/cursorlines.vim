" only diplay cursorlines in active window
if exists('g:loaded_cursorlines')
  finish
endif
let g:loaded_cursorlines = 1
let g:cursorlines_enabled = 1

augroup cursorlines
  au! cursorlines
  au! WinEnter,VimEnter,BufWinEnter * call cursorlines#refresh()
augroup END

function! cursorlines#refresh()
  if g:cursorlines_enabled
    for nr in range(1, winnr('$'))
      if l:nr == winnr()
        call setwinvar(l:nr, '&cursorline', 1)
      else
        call setwinvar(l:nr, '&cursorline', 0)
      endif
    endfor
  endif
endfunction
