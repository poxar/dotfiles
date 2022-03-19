setlocal spell
setlocal spelllang=en
compiler proselint
nnoremap <buffer> ml<cr> :Dispatch -compiler=proselint<cr>
