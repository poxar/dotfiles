#!/bin/sh
set -eu

APPNAME="$1"
CMD="$2"

WINDOW=$(niri msg -j windows | jq -r '.[] | "\(.id)\tapp:\(.app_id)\t\(.title)"' | grep "app:$APPNAME" || true)

if test -n "$WINDOW"; then
  ID=$(echo "$WINDOW" | fuzzel --dmenu --with-nth 3 --accept-nth 1 --auto-select)
  niri msg action focus-window --id "$ID"
else
  exec $CMD
fi
