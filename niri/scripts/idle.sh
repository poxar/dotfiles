#!/bin/sh
set -eu

LOCK_IMAGE="$HOME/Wallpaper/4k/coastline-mountain-pass-road-blurred.jpg"
LOCK_CMD="swaylock --key-hl-color ffffff --ring-color 000000 -i $LOCK_IMAGE -s fill"

if test "$(hostname)" = "leonis"; then
  swayidle \
    lock "$LOCK_CMD" \
    before-sleep "$LOCK_CMD"
else
  swayidle \
    lock "$LOCK_CMD" \
    timeout 300 'niri msg action power-off-monitors' \
    timeout 301 "$LOCK_CMD" \
    before-sleep "$LOCK_CMD"
fi
