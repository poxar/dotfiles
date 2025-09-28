#!/usr/bin/env fish

set -l updates (flatpak remote-ls --updates --columns=name | string split \n)

if test -n "$updates"
  notify-send -u critical "Flatpak updates available" "$(string join \n $updates)"
end
