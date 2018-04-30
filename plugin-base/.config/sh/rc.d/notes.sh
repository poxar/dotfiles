
#
# notes
# A simple note taking system
#

NOTEDIR=${NOTEDIR:-"$HOME/.notes"}
export NOTEDIR

# edit/create note
n() {
  cd "$NOTEDIR" || return 1
  if test -z "$1" && _pd_check fzf; then
    $EDITOR "$(fzf)"
  else
    $EDITOR "$@"
  fi
  cd - || return 1
}

# delete note
nd() {
  rm -f "$NOTEDIR/$*"
}

# search notes contents
nf() {
  if test -n "$*"; then
    # to prevent grep from displaying the whole path
    cd "$NOTEDIR" || return 1
    grep -rni "$*" -- *
    cd - || return 1
  else
    echo "Usage: nf QUERY"
    return 1
  fi
}

# list notes
nls() {
  if _pd_check tree; then
    tree -DCcr --noreport "$NOTEDIR"
  else
    ls -cr "$NOTEDIR"
  fi
}

alias nl="nls | head -n 15"
