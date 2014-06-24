
#
# .zsh.d/caprica.zsh
#

export PATH="$HOME/.local/bin:$PATH"

export PATH="$HOME/.gem/ruby/2.1.0/bin:$PATH"
export GEM_HOME="$HOME/.gem/ruby/2.1.0"

# python virtualenv
export WORKON_HOME=~/.virtualenvs
export PROJECT_HOME=$PROJECTS
[[ -d $WORKON_HOME ]] && \
    source `which virtualenvwrapper.sh` &>/dev/null

# directories
hash -d shares=/run/user/1000/gvfs

alias dup="sudo duply sandisk"

alias t="todo.sh"
alias soon='todo.sh list | grep -E "due:`date +%Y-%m-%d`|due:`date -d tomorrow +%Y-%m-%d`"'

# google drive
alias gdrive="cd /media/storage/gdrive && grive"

# easy mounting of my nas
function mount-tauron() {
  udevil mount -o credentials=/home/pmi/.smbcred-tauron smb://pmi@tauron/$1
}
compctl -k "(pmi public backup download configuration)" mount-tauron
