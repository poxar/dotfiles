#!/bin/sh
set -eu

if test "$(file --brief --mime-type "$1")" = 'text/plain'; then
  cat "$1"
else
  echo "Binary file not previewed"
fi
