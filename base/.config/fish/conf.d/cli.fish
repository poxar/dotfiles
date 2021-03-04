# prepends sudo to the current commandline or removes it if present
function __prepend_sudo
  set -l sudo 'sudo'
  if set -q SUDO
    set sudo "$SUDO"
  end

  set -l old (commandline -j)

  if test -z "$old"
    set old (history -1)
  end

  set -l new old

  if string match -r "^[[:space:]]*$sudo.*" "$old" 2>&1 >/dev/null
    set new (string replace -r "^[[:space:]]*"$sudo"[[:space:]]*" "" "$old")
  else
    set new "$sudo $old"
  end

  commandline -rj "$new"
end

bind \cs __prepend_sudo

# jump after first word (ignoring sudo/doas)
function __command_position
  set -l cli (commandline -j)
  set -l cmd ""

  if string match -qr "^sudo " $cli
    set cmd (string match -r "^sudo \\w*" $cli)
  else if string match -qr "^doas " $cli
    set cmd (string match -r "^doas \\w*" $cli)
  else
    set cmd (string match -r "^\\w*" $cli)
  end

  commandline --cursor (string length $cmd)
end

bind \ea __command_position

# expands ... to ../..
function __magic_dot
  if string match "*.." (commandline -jc) 2>&1 >/dev/null
    commandline -ji '/..'
  else
    commandline -ji '.'
  end
end

bind . __magic_dot
