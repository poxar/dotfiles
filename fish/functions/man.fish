function man --wraps=man
  # set a maximum width of 80
  set -q MANWIDTH; or set -l MANWIDTH 80
  set -l width (tput cols)

  test "$width" -gt "$MANWIDTH"; and set width $MANWIDTH

  # use nvim as manpager if available
  if command -q nvim
    set -x MANPAGER nvim +Man!
    command man $argv
  else
    env \
      LESS_TERMCAP_mb=(printf "\\e[1;31m") \
      LESS_TERMCAP_md=(printf "\\e[1;31m") \
      LESS_TERMCAP_me=(printf "\\e[0m") \
      LESS_TERMCAP_se=(printf "\\e[0m") \
      LESS_TERMCAP_so=(printf "\\e[1;44;33m") \
      LESS_TERMCAP_ue=(printf "\\e[0m") \
      LESS_TERMCAP_us=(printf "\\e[1;32m") \
      MANWIDTH="$width" \
      man $argv
  end
end
