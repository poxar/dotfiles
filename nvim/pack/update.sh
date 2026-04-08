#!/bin/sh
set -eu
# Update plugins installed as subtrees and install missing plugins.

while read -r url; do
  name="$(basename "$url")"
  prefix="nvim/pack/plugins/start/$name"
  branch="$(git remote show "$url" | sed -n '/HEAD branch/s/.*: //p')"

  if test -d "$prefix"; then
    echo "Updating $name..."

    git subtree pull \
      --prefix "$prefix" "$url" "$branch" --squash \
      -m "nvim: Update $name"
  else
    echo "Installing $name..."

    git subtree add \
      --prefix "$prefix" "$url" "$branch" --squash \
      -m "nvim: Add $name as subtree"
  fi
done < nvim/pack/plugins.txt
