emulate zsh

# base is required
plugins=("base")

# load host specific plugins
[[ -d "$REPOSITORY/host-$HOST" ]] && plugins+=("host-$HOST")

# load os specific plugins
[[ $OSTYPE =~ .*gnu.* ]]      && plugins+=("os-gnu")
[[ $OSTYPE =~ .*freebsd.* ]]  && plugins+=("os-freebsd")

# guess if other plugins should be included
which "pacman"     &>/dev/null && plugins+=("plugin-archlinux")
which "aptitude"   &>/dev/null && plugins+=("plugin-aptitude")

which "ruby"       &>/dev/null && plugins+=("plugin-ruby")
which "ghc"        &>/dev/null && plugins+=("plugin-haskell")

which "ack"        &>/dev/null && plugins+=("plugin-ack")
which "ack-grep"   &>/dev/null && plugins+=("plugin-ack")
which "aunpack"    &>/dev/null && plugins+=("plugin-atool")
which "docker"     &>/dev/null && plugins+=("plugin-docker")
which "git"        &>/dev/null && plugins+=("plugin-git")
which "hg"         &>/dev/null && plugins+=("plugin-mercurial")
which "keychain"   &>/dev/null && plugins+=("plugin-keychain")
which "svn"        &>/dev/null && plugins+=("plugin-subversion")
which "tmux"       &>/dev/null && plugins+=("plugin-tmux")
which "etckeeper"  &>/dev/null && plugins+=("plugin-etckeeper")
which "overcommit" &>/dev/null && plugins+=("plugin-overcommit")

which Xorg         &>/dev/null && plugins+=("plugin-xorg")
which openbox      &>/dev/null && plugins+=("plugin-openbox")
which ratpoison    &>/dev/null && plugins+=("plugin-ratpoison")

# remove duplicates
typeset -U plugins
