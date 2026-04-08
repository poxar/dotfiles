#!/bin/sh
set -eu
# Install plugins missing from the worktree as subtrees.

while read -r url; do
  name="$(basename "$url")"
  prefix="nvim/pack/plugins/start/$name"

  if ! test -d "$prefix"; then
    echo "Installing $name..."

    branch="$(git remote show "$url" | sed -n '/HEAD branch/s/.*: //p')"

    git subtree add \
      --prefix "$prefix" "$url" "$branch" --squash \
      -m "nvim: Add $name as subtree"
  fi
done < nvim/pack/plugins.txt
