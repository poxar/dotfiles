
#
# editor
# configures the default editor
#

if _pd_check nvim; then
  EDITOR="nvim"
elif _pd_check vim; then
  EDITOR="vim"
elif _pd_check nvi; then
  EDITOR="nvi"
else
  EDITOR="vi"
fi

# escaped to expand on call not on definition
alias vi='$EDITOR'
alias vim='$EDITOR'

VISUAL=$EDITOR

export EDITOR
export VISUAL
