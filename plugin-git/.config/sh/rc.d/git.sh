alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gd="git diff"
alias gl="git l"
alias gco="git checkout"

g() {
  if test $# -gt 0; then
    git "$@"
  else
    git status --short
  fi
}
