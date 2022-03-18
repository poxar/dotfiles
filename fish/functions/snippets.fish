function snippets --description="Copy a snippet into the system clipboard"
  pushd $XDG_CONFIG_HOME/snippets

  set -l clip_cmd
  if test $XDG_SESSION_TYPE = "wayland"
    set clip_cmd wl-copy
  else
    set clip_cmd xsel -b
  end

  head -c -1 (rg --files | sk --exact --select-1 --preview 'cat {}') | $clip_cmd
  popd
end
