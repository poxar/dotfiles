nnoremap <buffer> mt<cr> :Dispatch make test<cr>
nnoremap <buffer> ml<cr> :Dispatch php -l %<cr>
nnoremap <buffer> mc<cr> :Dispatch php -l %<cr>

if executable('uctags') && filereadable('tags')
  augroup autotags
    au! BufWrite *.php exec "Start! uctags -R ."
  augroup END
elseif executable('ctags') && filereadable('tags')
  augroup autotags
    au! BufWrite *.php exec "Start! ctags -R ."
  augroup END
endif
