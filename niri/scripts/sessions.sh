#!/bin/sh
set -eu

cd ~/Code

dir="$(dirname "$0")"
sel="$(fd -Is 'Session.vim' | xargs dirname | fuzzel --dmenu)"
cmd="ghostty --working-directory="$HOME/Code/$sel" -e nvim -S Session.vim"

if test -n "$sel"; then
  "$dir/run-or-raise.sh" ".* :: $sel :: nvim" "$cmd"
fi
