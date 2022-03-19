if exists('current_compiler')
  finish
endif
let current_compiler = 'bloop'

if exists(':CompilerSet') != 2          " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

let &l:errorformat = '%f:%l:%c:\ %m,'
CompilerSet makeprg=flawfinder\ --columns\ --dataonly\ --quiet\ --singleline\ %:S
silent CompilerSet errorformat

let &cpo = s:cpo_save
unlet s:cpo_save
