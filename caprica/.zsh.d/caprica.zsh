
#
# .zsh.d/caprica.zsh
#

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.0.0/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.1.0/bin:$PATH"

export GEM_HOME="$HOME/.gem/ruby/2.0.0"

# python virtualenv
export WORKON_HOME=~/.virtualenvs
export PROJECT_HOME=$PROJECTS
[[ -d $WORKON_HOME ]] && \
    source `which virtualenvwrapper.sh` &>/dev/null

hash -d data=$HOME/data
hash -d dokumente=~data/Dokumente
hash -d dropbox=~data/Dropbox
hash -d bib=~data/Bibliothek
hash -d uni=~dropbox/Uni
hash -d shares=/run/user/1000/gvfs

alias dup="sudo duply mybook"

function mount-tauron() {
  udevil mount -o credentials=/home/philipp/.smbcred-tauron smb://pmi@tauron/$1
}
compctl -k "(pmi public backup download configuration)" mount-tauron

