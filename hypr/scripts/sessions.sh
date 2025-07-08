#!/bin/sh
set -eu

cd ~/Code

sel="$(fd -Is 'Session.vim' | xargs dirname | fuzzel --dmenu)"

if test -n "$sel"; then
  exec ghostty --working-directory="$HOME/Code/$sel" -e nvim -S Session.vim
fi
