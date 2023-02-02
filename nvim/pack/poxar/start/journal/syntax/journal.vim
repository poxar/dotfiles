if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'journal'
endif

syn match journalNote "^- .\+$"
syn match journalGratitude "^+ .\+$"
syn match journalTodo "^· .\+$"
syn match journalTodo "^\. .\+$"
syn match journalDone "^x .\+$"
syn match journalMigrated "^> .\+$"
syn match journalMigrated "^< .\+$"
syn match journalDeleted "^\~ .\+$"

hi def link journalNote String
hi def link journalGratitude Type
hi def link journalDone Comment
hi def link journalMigrated Comment
hi def journalDeleted term=strikethrough cterm=strikethrough gui=strikethrough

syn match journalDay "^## .\+$"
syn match journalMonth "^# .\+$"

hi def link journalDay Identifier
hi def link journalMonth Title
