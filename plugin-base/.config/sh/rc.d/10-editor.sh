
#
# editor
# configures the default editor
#

if _pd_check vim; then
  EDITOR="vim"
else
  EDITOR="vi"
fi

# escaped to expand on call not on definition
alias vi='$EDITOR'
alias vim='$EDITOR'

VISUAL=$EDITOR

export EDITOR
export VISUAL
