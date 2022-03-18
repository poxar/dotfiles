function snipedit --description="Edit snippets"
  pushd $XDG_CONFIG_HOME/snippets
  $EDITOR
  popd
end
