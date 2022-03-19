setlocal omnifunc=csscomplete#CompleteCSS
nnoremap gK :silent !open dash://css:<cword><cr>
nnoremap <buffer> ml<cr> :Dispatch -compiler=csslint<cr>
