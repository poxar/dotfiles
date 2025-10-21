#!/bin/sh
set -eu

niri msg -j windows \
  | jq -r '.[] | "\(.id)\t\(.title)"' \
  | fuzzel --dmenu --with-nth 2 --accept-nth  1 \
  | xargs niri msg action focus-window --id
