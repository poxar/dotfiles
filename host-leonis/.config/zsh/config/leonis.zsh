export PROJECTS=$HOME/Development

# python virtualenv
export WORKON_HOME=~/.virtualenvs
export PROJECT_HOME=$PROJECTS
[[ -d $WORKON_HOME ]] && \
    source `which virtualenvwrapper.sh` &>/dev/null

# directories
hash -d shares=/run/user/1000/gvfs
hash -d media=/run/media/pmi

