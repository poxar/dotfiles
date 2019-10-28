command -sq yarn
and function yarn --wraps=yarn
  set -l config

  if set -q $XDG_CONFIG_HOME
    set config "$XDG_CONFIG_HOME/yarn/config"
  else
    set config "$HOME/.config/yarn/config"
  end

  command yarn --use-yarnrc "$config" $argv
end
