if command -q zoxide
  set -x _ZO_EXCLUDE_DIRS "$HOME:$HOME/.local/*:$HOME/.var/*"

  zoxide init fish | source

  alias c z

  function __skim_zoxide
    set -l line (zoxide query -l | sk)
    commandline --replace "cd \"$line\""
    commandline --is-valid; and commandline -f execute
  end
  bind \ez __skim_zoxide
else
  alias c cd
end
