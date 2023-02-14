nnoremap <buffer> ml<cr> :Dispatch tidy -quiet -errors --gnu-emacs yes %<cr>
nnoremap <buffer> mf<cr> :silent %!prettier --stdin-filepath %<cr>
