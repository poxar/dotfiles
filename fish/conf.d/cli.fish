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

# skim files
# Having these as shortcuts enables history search on the actual results
if command -q sk; and command -q rg
  function __skim_files
    set -l file (rg --files | sk)
    if test -n "$file"
      commandline --append '"'
      commandline --append $file
      commandline --append '"'
      commandline --cursor (math (commandline --cursor) + (string length $file) + 2)
    end
  end

  bind \co __skim_files

  function __skim_grep
    set -l rg_cmd 'rg --smart-case --color=always --line-number "{}"'
    set -l line (sk --ansi --interactive --cmd $rg_cmd | awk -F: '{ print $1" +"$2 }')
    if test -n "$line"
      commandline --replace "$EDITOR $line"
      commandline --cursor (string length "$EDITOR $line")
    end
  end

  bind \cg __skim_grep
end
