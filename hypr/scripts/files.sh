#!/bin/sh
set -eu

cd "$HOME"

sel="$(find Documents Downloads Pictures \
    -not -path '*/.*' \
    -type f \
    -printf "%T@\t%p\n" \
    | sort -r -n \
    | awk -F '\t' '{ print $2 }' \
    | fuzzel --dmenu)"

if test -n "$sel"; then
  handlr open "$HOME/$sel"
fi
