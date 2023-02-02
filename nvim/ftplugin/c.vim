setlocal cindent
let b:man_default_sects = '3,2'

command! Alt ClangdSwitchSourceHeader
command! A ClangdSwitchSourceHeader

if executable('uctags') && filereadable('tags')
  augroup autotags
    au! BufWrite *.c exec "Start! uctags -R ."
    au! BufWrite *.h exec "Start! uctags -R ."
  augroup END
elseif executable('ctags') && filereadable('tags')
  augroup autotags
    au! BufWrite *.c exec "Start! ctags -R ."
    au! BufWrite *.h exec "Start! ctags -R ."
  augroup END
endif
