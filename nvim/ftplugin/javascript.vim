setlocal omnifunc=javascriptcomplete#CompleteJS
nnoremap gK :silent !open dash://javascript:<cword><cr>
nnoremap <buffer> ml<cr> :Dispatch -compiler=eslint<cr>
