" use ripgrep if available
if executable('rg')
  let &grepprg='rg --smart-case --vimgrep'
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Make grep silent by launching it in a subshell
" This additionally allows expansions in the arguments
function! Grep(...)
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

" Open the quickfix window automatically
" This only opens the window if there are valid entries
augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

nnoremap <leader>gg :Grep<space>
nnoremap <leader>gw :Grep <cword> . <cr>
