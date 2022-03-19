setlocal textwidth=100
setlocal colorcolumn=+1
nnoremap gK :silent !open dash://scala:<cword><cr>
compiler bloop
