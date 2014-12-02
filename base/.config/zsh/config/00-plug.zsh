function zsh_plug() {
  if ! test -d "$ZBUNDLE/$1"; then
    mkdir -p "$ZBUNDLE/$(dirname $1)"
    git clone "https://github.com/$1" "$ZBUNDLE/$1"
  fi

  if test -n "$2"; then
    case "$2" in
      fpath)
        fpath=("$ZBUNDLE/$1/$3" $fpath)
        ;;
      source)
        source "$ZBUNDLE/$1/$3"
        ;;
      *)
        echo "Wrong option $2 $3"
    esac
  fi
}

