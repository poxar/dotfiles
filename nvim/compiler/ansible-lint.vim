if exists("current_compiler")
  finish
endif
let current_compiler = "ansible_lint"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:save_cpo = &cpo
set cpo-=C

CompilerSet makeprg=ansible-lint
CompilerSet errorformat=%f:%l\ %m,%f:%l
