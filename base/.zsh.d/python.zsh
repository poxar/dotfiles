
#
# ~/.zsh/python.zsh
# ZSH settings for python development
#

# pip install --user
export PATH="$HOME/.local/bin:$PATH"

# python virtualenv
export WORKON_HOME=~/.virtualenvs
export PROJECT_HOME=$PROJECTS
[[ -d $WORKON_HOME ]] && \
    source `which virtualenvwrapper.sh` &>/dev/null
