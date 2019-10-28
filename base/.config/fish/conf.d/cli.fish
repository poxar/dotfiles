# prepends sudo to the current commandline or removes it if present
function __prepend_sudo
  set -l sudo 'sudo'
  if set -q SUDO
    set sudo "$SUDO"
  end

  set -l old (commandline -j)
  set -l new old

  if string match -r "^[[:space:]]*$sudo.*" "$old" 2>&1 >/dev/null
    set new (string replace -r "^[[:space:]]*"$sudo"[[:space:]]*" "" "$old")
  else
    set new "$sudo $old"
  end

  commandline -rj "$new"
end

bind \cs __prepend_sudo

# prepends sudo to the last entered command
function __last_sudo
  set -l sudo 'sudo'
  if set -q SUDO
    set sudo "$SUDO"
  end

  commandline "$sudo $history[1]"
end

bind \es __last_sudo

# expands ... to ../..
function __magic_dot
  if string match "*.." (commandline -jc) 2>&1 >/dev/null
    commandline -ji '/..'
  else
    commandline -ji '.'
  end
end

bind . __magic_dot
