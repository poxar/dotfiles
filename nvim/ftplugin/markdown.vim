setlocal tabstop=4
setlocal noexpandtab

setlocal nonumber
setlocal norelativenumber

setlocal nolist

setlocal suffixesadd=.md,.markdown,.txt

let g:vim_markdown_strikethrough = 1
let g:vim_markdown_folding_disabled = 1

" swap j/k/0/$ and gj/gk/g0/g$
" so the g variations work on physical lines and the default ones on display
" lines unless a count is given, then act normally
nnoremap <buffer> <expr> j  (v:count == 0 ? 'gj' : 'j')
nnoremap <buffer> <expr> k  (v:count == 0 ? 'gk' : 'k')
nnoremap <buffer> <expr> gj (v:count == 0 ? 'j' : 'gj')
nnoremap <buffer> <expr> gk (v:count == 0 ? 'k' : 'gk')
nnoremap <buffer> g0 0
nnoremap <buffer> 0 g0
nnoremap <buffer> $ g$
nnoremap <buffer> g$ $

nnoremap <buffer> gf vi]gf

iabbrev <buffer> ... …

command! -buffer -nargs=0 Backlinks execute "silent grep! \\\\\\[\\\\\\[".expand("%:t:r") . " | cw"
