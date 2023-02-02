# Use A-W to delete bigword instead of a quick help
bind \ew backward-kill-bigword

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
