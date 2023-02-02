" PEP8 settings
setlocal textwidth=79  " lines longer than 79 columns will be broken
setlocal shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
setlocal tabstop=4     " a hard TAB displays as 4 columns
setlocal expandtab     " insert spaces when hitting TABs
setlocal softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
setlocal shiftround    " round indent to multiple of 'shiftwidth'
setlocal autoindent    " align the new line indent with the previous line

nnoremap <buffer> ml<cr> :Dispatch -compiler=flake8<cr>
nnoremap <buffer> mf<cr> :w<cr>:silent !black --quiet %<cr>:e<cr>
