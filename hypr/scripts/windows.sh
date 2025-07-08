#!/bin/sh
set -eu

hyprctl -j clients \
  | jq -r '.[] | "address:\(.address)\t\(.class): \(.title)"' \
  | fuzzel --dmenu --with-nth 2 --accept-nth 1 \
  | xargs hyprctl dispatch focuswindow
