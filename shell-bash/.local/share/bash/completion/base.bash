_c() {
  cd "$PROJECTS" || return 1
  COMPREPLY=($(compgen -d "$2"))
  cd - || return 1
}
complete -o nospace -F _c c

_n() {
  cd "$NOTEDIR" || return 1
  COMPREPLY=($(compgen -fd "$2"))
  cd - || return 1
}
complete -o nospace -F _n n
complete -o nospace -F _n nd
