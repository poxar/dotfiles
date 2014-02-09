
#
# .zsh/svn.zsh
#

alias s="svn"
function s() {
  if [[ $# > 0 ]]; then
    svn $@
  else
    svn status
  fi
}
compdef s='svn'

