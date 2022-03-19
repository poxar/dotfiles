" Language:    Bloop Scala Build Server (https://scalacenter.github.io/bloop)

if exists('current_compiler')
  finish
endif
let current_compiler = 'bloop'

if exists(':CompilerSet') != 2          " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet errorformat=
      \%E\ %#[E]\ %f:%l:%c:\ %m,%C\ %#[E]\ %p^,%-C%.%#,%Z,
      \%W\ %#[W]\ %f:%l:%c:\ %m,%C\ %#[W]\ %p^,%-C%.%#,%Z,
      \%I\ %#%f:%l:%c:\ %m,%C\ %#[I]\ %p^,%-C%.%#,%Z,
      \%-G%.%#

CompilerSet makeprg=bloop\ compile\ --reporter\ scalac\ --no-color

let &cpo = s:cpo_save
unlet s:cpo_save
