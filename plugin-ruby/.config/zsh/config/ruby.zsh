# add rbenv to the path if necessary (e.g. not installed globally)
[[ -d "$HOME/.rbenv/bin" ]] && \
  export PATH="$HOME/.rbenv/bin:$PATH"

# initalize rbenv
[[ -x =rbenv ]] && \
  eval "$(rbenv init -)"

# select the highest (newest) available ruby version for gems
export GEM_HOME=$(echo $HOME/.gem/ruby/*([-1]))
export PATH="$GEM_HOME/bin:$PATH"

# colorful ri in less
RI_EXEC=$(which ri)
function ri() {
  PAGER="less -r" $RI_EXEC --format=ansi $@
}

alias be='bundle exec'
