if exists("current_compiler") | finish | endif
let current_compiler = "csslint"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

let &l:errorformat = 
      \ '%.%./%f:%l%.%c%.%#: %trror: %m,' .
      \ '%.%./%f:%l%.%c%.%#: %tarning: %m'

CompilerSet makeprg=ninja\ -C\ build
silent CompilerSet errorformat

let &cpo = s:cpo_save
unlet s:cpo_save
