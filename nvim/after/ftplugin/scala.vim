if isdirectory('.bloop')
  compiler bloop

  if ! exists('g:bloop_project')
    let g:bloop_project='root'
  endif

  " I somehow have to override the compiler every time because Dispatch seems to
  " pull 'root' into makeprg for some reason which breaks consecutive calls to
  " `:Make root`.
  nnoremap <expr><buffer> m<cr>  ':compiler bloop<cr>:Make '.g:bloop_project.'<cr>'
  nnoremap <expr><buffer> mt<cr> ':compiler bloop<cr>:Make '.g:bloop_project.'-test<cr>'
  nnoremap <expr><buffer> mtt    ':Start bloop test '.g:bloop_project
  nnoremap <expr><buffer> mr<cr> ':Start bloop run '.g:bloop_project.'<cr>'
  nnoremap <expr><buffer> mc<cr> ':Start bloop clean '.g:bloop_project.'<cr>'
endif
