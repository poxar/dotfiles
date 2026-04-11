if exists('g:loaded_statusline')
  finish
endif
let g:loaded_statusline = 1
set statusline=%!statusline#status()

let g:currentmode={
      \ 'n':       ' Normal',
      \ 'i':       ' Insert',
      \ 'v':       ' Visual',
      \ 't':       ' Terminal',
      \ 'c':       ' Command',
      \ 's':       ' Substitute',
      \ 'R':       ' Replace',
      \ 'V':       ' V·Line',
      \ 'Rv':      ' V·Replace',
      \ "\<C-V>":  ' V·Block',
      \}

function! statusline#status()
  let l:active = g:statusline_winid == win_getid()
  let l:bufnum = winbufnr(win_getid())
  let l:ftype = getbufvar(l:bufnum, '&filetype')
  let l:btype = getbufvar(l:bufnum, '&buftype')

  if l:active
    if l:ftype ==# 'help'
      return ' Help %t%=%P '
    elseif l:ftype ==# 'man'
      return ' Man %t%=%P '
    elseif l:btype ==# 'quickfix'
      return ' Quickfix %t%=%P '
    elseif l:btype ==# 'terminal'
      return '%* Terminal %t'
    elseif getbufvar(l:bufnum, '&previewwindow')
      return ' Preview %t%=%P '
    endif
  endif

  let l:modified = getbufvar(bufnum, '&modified')
  let l:readonly = getbufvar(bufnum, '&readonly')

  let l:status = ''

  if l:active
    let l:status.=readonly ? ' RO' : ''
  endif

  let l:status.=' %{statusline#path()}'
  let l:status.=modified ? '+' : ''
  let l:status.='%='

  if l:active
    let l:status.=g:currentmode[mode()]
    let l:status.=' %4l:%-3v'
  else
    let l:status.='%p%% '
  endif

  return l:status
endfunction


" Shows a short yet descriptive pathname of the file in the current buffer.
function! statusline#path()
  " Get the path of the file in the current buffer
  let l:path = expand('%:~:.')

  if len(l:path) > 50
    let l:path = pathshorten(l:path)
  endif

  " Show a label for files without a filename
  if !strlen(l:path)
    let l:path = '[No Name]'
  endif

  return l:path
endfunction
