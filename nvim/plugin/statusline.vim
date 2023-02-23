if exists('g:loaded_statusline')
  finish
endif
let g:loaded_statusline = 1
let g:statusline_mode_enabled = 1

augroup statusline
  au! statusline
  au! WinEnter,VimEnter,BufWinEnter * call statusline#refresh()
augroup END

function! statusline#refresh()
  for nr in range(1, winnr('$'))
    call setwinvar(l:nr, '&statusline', '%!statusline#status(' . l:nr . ')')
  endfor
endfunction

let g:currentmode={
      \ 'n':       'Normal',
      \ 'i':       'Insert',
      \ 'v':       'Visual',
      \ 't':       'Terminal',
      \ 'c':       'Command',
      \ 'R':       'Replace',
      \ 'V':       'V·Line',
      \ 'Rv':      'V·Replace',
      \ "\<C-V>":  'V·Block',
      \}

function! statusline#status(nr)
  let l:active = a:nr == winnr()
  let l:bufnum = winbufnr(a:nr)
  let l:ftype = getbufvar(l:bufnum, '&filetype')
  let l:btype = getbufvar(l:bufnum, '&buftype')
  let l:name = bufname(l:bufnum)

  if l:ftype ==# 'help'
    return ' Help %t%=%P '
  elseif l:ftype ==# 'man'
    return ' Man %t%=%P '
  elseif l:btype ==# 'quickfix'
    return ' Quickfix %t%=%P '
  elseif l:btype ==# 'terminal'
    return '%2* %{g:currentmode[mode()]} %* Terminal %t'
  elseif getbufvar(l:bufnum, '&previewwindow')
    return ' Preview %t%=%P '
  endif

  let l:modified = getbufvar(bufnum, '&modified')
  let l:readonly = getbufvar(bufnum, '&readonly')

  let l:status = ''
  if g:statusline_mode_enabled && l:active
    let l:status.='%2* %{g:currentmode[mode()]} %*'
  endif
  let l:status.=readonly ? '%1* RO %*' : ''
  let l:status.=' %{statusline#path()}'
  let l:status.=modified ? ' +' : ''
  let l:status.='%='

  if l:active
    let l:status.='%2* %{statusline#stats()}%*'
    let l:status.=' %4l:%-3v'
  else
    let l:status.='%p%% '
  endif

  return l:status
endfunction


" Shows a short yet descriptive pathname of the file in the current buffer.
function! statusline#path()
  " Get the path of the file in the current buffer
  let l:path = expand('%:.')
  " Always show the path unix style
  let l:path = substitute(l:path,'\','/','g')
  " Shorten $HOME
  let l:path = substitute(l:path, '^\V' . $HOME, '~', '')
  " Apply all built in simplifications
  let l:path = simplify(l:path)

  if len(l:path) > 50
    let l:path = pathshorten(l:path)
  endif

  " Show a label for scratch buffers and the like
  if !strlen(l:path)
    let l:path = '[No Name]'
  endif

  return l:path
endfunction


" Collect statistics about the file/project
function! statusline#stats()
  let l:filestats = ''

  " Git branch
  if exists('g:loaded_fugitive') && strlen(FugitiveHead())
    let l:filestats .= FugitiveHead() . ' '
  endif

  " Filetype or none
  if strlen(&filetype)
    let l:filestats .= &ft . ' '
  else
    let l:filestats .= 'none '
  endif

  " Show me if the file has a strange encoding
  if strlen(&fenc) && &fenc !=# 'utf-8'
    let l:filestats .= &fenc . ' '
  elseif &enc !=# 'utf-8'
    let l:filestats .= &enc . ' '
  endif

  " Show me if the file has strange line endings
  if strlen(&fileformat) && &fileformat !=# 'unix'
    let l:filestats .= &fileformat . ' '
  endif

  return l:filestats
endf
