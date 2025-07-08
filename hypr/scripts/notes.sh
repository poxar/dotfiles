#!/bin/sh
set -eu

cd "$HOME/Notes"

sel="$(fd --type f --exclude Archive | fuzzel --dmenu)"

if test -n "$sel"; then
  exec ghostty --working-directory="$HOME/Notes" -e nvim "$sel"
fi
