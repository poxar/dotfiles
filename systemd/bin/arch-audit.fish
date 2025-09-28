#!/usr/bin/env fish

set -l updates (arch-audit -u | string split \n)

if test -n "$updates"
  notify-send -u critical "Critical updates available" "$(string join \n $updates)"
end
