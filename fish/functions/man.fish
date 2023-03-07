function man --wraps=man
  # set a maximum width of 80
  set -q MANWIDTH; or set -l MANWIDTH 80
  set -l width (tput cols)

  test "$width" -gt "$MANWIDTH"; and set width $MANWIDTH
  env MANWIDTH="$width" man $argv
  end
end
