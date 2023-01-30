nnoremap gK :silent !open dash://typescript:<cword><cr>
nnoremap <buffer> ml<cr> :Dispatch -compiler=eslint<cr>
nnoremap <buffer> mf<cr> :silent %!prettier --stdin-filepath %<cr>
