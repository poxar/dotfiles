setlocal omnifunc=htmlcomplete#CompleteTags
nnoremap gK :silent !open dash://html:<cword><cr>
nnoremap <buffer> ml<cr> :Dispatch -compiler=proselint<cr>
nnoremap <buffer> mf<cr> :silent %!prettier --stdin-filepath %<cr>
