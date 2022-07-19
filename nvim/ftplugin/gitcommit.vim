setlocal spell
setlocal spelllang=en_gb
compiler proselint
nnoremap <buffer> ml<cr> :Dispatch -compiler=proselint<cr>
