command -sq yarn
and function yarn --wraps=yarn
  set -l config

  if set -q $XDG_CONFIG_HOME
    set config "$XDG_CONFIG_HOME/yarn/config"
  else
    set config "$HOME/.config/yarn/config"
  end

  set -l prefix (command yarn --use-yarnrc "$config" config get prefix)
  if test "$prefix" != "$HOME/.local"
    command yarn --use-yarnrc "$config" config set prefix "$HOME/.local"
  end

  command yarn --use-yarnrc "$config" $argv
end
