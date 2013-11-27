
#
# .zsh/xorg.zsh
#

alias v="gvim"
alias vv="gvim --remote-silent"

function o() {
  xdg-open $* &>/dev/null &
}
