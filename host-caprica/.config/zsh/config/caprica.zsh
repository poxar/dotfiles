export PROJECTS=$HOME/Developement

# python virtualenv
export WORKON_HOME=~/.virtualenvs
export PROJECT_HOME=$PROJECTS
[[ -d $WORKON_HOME ]] && \
    source `which virtualenvwrapper.sh` &>/dev/null

# directories
hash -d shares=/run/user/1000/gvfs

alias t="todo.sh"
alias soon='todo.sh list | grep -E "due:`date +%Y-%m-%d`|due:`date -d tomorrow +%Y-%m-%d`"'

