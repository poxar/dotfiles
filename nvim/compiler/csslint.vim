if exists("current_compiler") | finish | endif
let current_compiler = "csslint"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

let &l:errorformat =
      \ '%f: line %l\, col %c\, %m,' .
      \ '%f: %m'

CompilerSet makeprg=csslint\ --format=compact\ %:S
silent CompilerSet errorformat

let &cpo = s:cpo_save
unlet s:cpo_save
