nnoremap <buffer> ml<cr> :Dispatch -compiler=proselint<cr>

setlocal omnifunc=htmlcomplete#CompleteTags

setlocal complete+=kspell " Complete from current spell checking
setlocal complete+=s " Complete from thesaurus

setlocal spelllang=en

setlocal tabstop=4
setlocal noexpandtab

setlocal nonumber

let g:vim_markdown_strikethrough = 1

" swap j/k/0/$ and gj/gk/g0/g$
" so the g variations work on physical lines and the default ones on display
" lines unless a count is given, then act normally
nnoremap <expr> j  (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k  (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> gj (v:count == 0 ? 'j' : 'gj')
nnoremap <expr> gk (v:count == 0 ? 'k' : 'gk')
nnoremap g0 0
nnoremap 0 g0
nnoremap $ g$
nnoremap g$ $

iabbrev <buffer> ... …
