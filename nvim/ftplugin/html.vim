setlocal omnifunc=htmlcomplete#CompleteTags
nnoremap gK :silent !open dash://html:<cword><cr>
nnoremap <buffer> ml<cr> :Dispatch -compiler=proselint<cr>
