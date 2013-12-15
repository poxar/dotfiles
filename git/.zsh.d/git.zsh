
#
# .zsh/plugin/git.zsh
#

function g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status --short
  fi
}
compdef g='git'

alias ga="git add"
alias garm="git add -A"
alias gc="git commit"
alias gca="git commit -a"

alias gcl="git clone"
alias gp="git push"
alias gpu="git pull"

alias gco="git checkout"
alias gbr="git branch"

alias gs="git status --no-short"
alias gd="git diff"

alias gundo="git reset --soft HEAD~1"

alias gl="git l"
