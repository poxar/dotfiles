if command -q sk
  # search for files
  function __skim_files
    set -l file (fd --type file --hidden | sk)
    if test -n "$file"
      commandline --append '"'
      commandline --append $file
      commandline --append '"'
      commandline --cursor (math (commandline --cursor) + (string length $file) + 2)
    end
  end
  bind \co __skim_files

  # grep through all files and open in editor
  function __skim_grep
    set -l line (rg --color=always --line-number "" | sk --ansi | awk -F: '{ print $1" +"$2 }')
    if test -n "$line"
      commandline --replace "$EDITOR $line"
      commandline --cursor (string length "$EDITOR $line")
      commandline --is-valid; and commandline -f execute
    end
  end
  bind \cg __skim_grep

  # quickly cd into directory
  function __skim_cd
    set -l line (fd --type directory --hidden | sk)
    if test -n "$line"
      commandline --replace "cd \"$line\""
      commandline --is-valid; and commandline -f execute
    end
  end
  bind \ec __skim_cd

  # search through history
  function __skim_history
    set -l line (history | sk)
    if test -n "$line"
      commandline --replace "$line"
    end
  end
  bind \er __skim_history
end
