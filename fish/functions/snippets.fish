function snippets --description="Copy a snippet into the system clipboard"
  pushd $XDG_CONFIG_HOME/snippets

  set -l clip_cmd
  if test $XDG_SESSION_TYPE = "wayland"
    set clip_cmd wl-copy
  else
    set clip_cmd xsel -b
  end

  set -l snippet (rg --files | sk --exact --select-1 --preview 'cat {}')

  if test -n "$snippet"
    head -c -1 $snippet | $clip_cmd
  end

  popd
end
