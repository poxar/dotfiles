_git_hookup() {
  COMPREPLY=($(compgen -W "help ctags todo" -- "$cur"))
}

if type __git_complete >/dev/null 2>&1; then
  __git_complete g _git_main
else
  type _completion_loader >/dev/null 2>&1 && _completion_loader git
  complete -o bashdefault -o default -o nospace -F _git g
fi

