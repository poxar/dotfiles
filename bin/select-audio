#!/bin/sh
set -eu

pactl list short sinks \
  | cut -f 2 \
  | fuzzel --dmenu \
  | xargs pactl set-default-sink
