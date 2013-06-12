
#
# .zsh/autoenv.zsh
# aliases and functions for usage with autoenv
#

use_env() {
  typeset venv
  venv="$1"
  if [[ "${VIRTUAL_ENV:t}" != "$venv" ]]; then
    if workon | grep -q "$venv"; then
      workon "$venv"
    else
      echo -n "Create virtualenv $venv now? (Yn) "
      read answer
      if [[ "$answer" == "Y" ]]; then
        REQS_ARG=""
        PYTHONEXE_ARG=""
        if [ -f requirements.txt ]; then
          REQS_ARG="-r requirements.txt"
        fi
        if [ `command -v python2` ]; then
          echo -n "Use python2 instead of python? (Yyn) "
          read answer
          if [[ $answer =~ ^[Yy]$ ]]; then
            PYTHONEXE_ARG="--python=python2"
          fi
        fi
        mkvirtualenv $REQS_ARG $PYTHONEXE_ARG "$venv"
      fi
    fi
    echo "now on env $VIRTUAL_ENV"
  else
    echo "failed to open env $1"
  fi
}

leave_env() {
  if which deactivate &>/dev/null
  then
    echo "leaving env $VIRTUAL_ENV"
    deactivate
  fi
}

source ~/.autoenv/activate.sh
