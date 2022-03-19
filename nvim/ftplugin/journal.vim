iabbrev <buffer> d ## <C-R>=strftime("%Y_%m_%d, %A")<cr>
iabbrev <buffer> #d ## <C-R>=strftime("%Y_%m_%d, %A")<cr>

iabbrev <buffer> m # <C-R>=strftime("%Y_%m, %B")<cr>
iabbrev <buffer> #m # <C-R>=strftime("%Y_%m, %B")<cr>

iabbrev <buffer> . ·

setlocal formatoptions=

nnoremap <buffer> <leader>O ggO## <C-R>=strftime("%Y_%m_%d, %A")<cr><cr><cr><cr><esc>ki
nnoremap <buffer> <leader>d ggO## <C-R>=strftime("%Y_%m_%d, %A")<cr><cr><cr><cr><esc>ki
nnoremap <buffer> <leader>x 0rx
nnoremap <buffer> <leader>> yy0r>
nnoremap <buffer> <leader>< yy0r<
nnoremap <buffer> <leader>~ 0r~

nnoremap <buffer> <leader>/m /^# <cr>
nnoremap <buffer> <leader>/d /^## <cr>
