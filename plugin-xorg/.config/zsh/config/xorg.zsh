
#
# .zsh/xorg.zsh
#

alias v="gvim"
alias vv="gvim --remote-silent"

alias clipboard='xclip -selection c; \
  notify-send --icon=gtk-paste "Copied to clipboard." \
  2>/dev/null'
