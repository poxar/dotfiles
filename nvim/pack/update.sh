#!/bin/sh
set -eu

while read -r url; do
  name="$(basename "$url")"
  prefix="nvim/pack/plugins/start/$name"
  branch="$(git remote show "$url" | sed -n '/HEAD branch/s/.*: //p')"

  if test -d "$prefix"; then
    git subtree pull \
      --prefix "$prefix" "$url" "$branch" --squash \
      -m "nvim: Update $name"
  else
    git subtree add \
      --prefix "$prefix" "$url" "$branch" --squash \
      -m "nvim: Add $name as subtree"
  fi
done < nvim/pack/plugins.txt
