# disallow completion on empty commandline
shopt -s no_empty_cmd_completion

# CD
shopt -s autocd   # allow directories as commands
shopt -s cdspell  # correct spelling in cd
shopt -s dirspell # correct spelling for all directories

# automatically populate the dirstack
cd () {
  if test $# -eq 0; then
    if test "$PWD" == "$HOME"; then
      return 0
    else
      pushd "$HOME" >/dev/null || return 1
    fi
  else
    pushd "$@" >/dev/null || return 1
  fi
}

# Globbing
shopt -s extglob  # allow multimatches with |
shopt -s globstar # allow ** as glob

# check available columns after each command
shopt -s checkwinsize

## History
mkdir -p "$XDG_DATA_HOME/bash"
export HISTFILE="$XDG_DATA_HOME/bash/history"

# never prune the history but only load the newest 20000 entries
export HISTFILESIZE=
export HISTSIZE=20000

export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S  '

# make sharing the history between instances possible
shopt -s histappend

# simpler multiline entries
shopt -s cmdhist

# show history substitutions before execution
shopt -s histverify

# Ignore commands starting with space
export HISTCONTROL='ignorespace'
export HISTIGNORE="ls:[bf]g:exit:clear"
