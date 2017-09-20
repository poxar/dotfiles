emulate zsh

# base is required
plugins=("base")

# load host specific plugins
[[ -d "$REPOSITORY/host-$(hostname -s)" ]] && plugins+=("host-$(hostname -s)")

# load os specific plugins
[[ $OSTYPE =~ .*gnu.* ]]      && plugins+=("os-gnu")
[[ $OSTYPE =~ .*freebsd.* ]]  && plugins+=("os-freebsd")

# guess if other plugins should be included
which "pacman"     &>/dev/null && plugins+=("plugin-archlinux")
which "aptitude"   &>/dev/null && plugins+=("plugin-aptitude")

which "rustc"      &>/dev/null && plugins+=("plugin-rust")
which "ruby"       &>/dev/null && plugins+=("plugin-ruby")
which "ghc"        &>/dev/null && plugins+=("plugin-haskell")
which "sbt"        &>/dev/null && plugins+=("plugin-scala")

which "ssh"        &>/dev/null && plugins+=("plugin-ssh")
which "gpg2"       &>/dev/null && plugins+=("plugin-gnupg")
which "ack"        &>/dev/null && plugins+=("plugin-ack")
which "ack-grep"   &>/dev/null && plugins+=("plugin-ack")
which "sift"       &>/dev/null && plugins+=("plugin-sift")
which "aunpack"    &>/dev/null && plugins+=("plugin-atool")
which "docker"     &>/dev/null && plugins+=("plugin-docker")
which "etckeeper"  &>/dev/null && plugins+=("plugin-etckeeper")
which "git"        &>/dev/null && plugins+=("plugin-git")
which "hg"         &>/dev/null && plugins+=("plugin-mercurial")
which "npm"        &>/dev/null && plugins+=("plugin-nodejs")
which "pass"       &>/dev/null && plugins+=("plugin-pass")
which "svn"        &>/dev/null && plugins+=("plugin-subversion")
which "tmux"       &>/dev/null && plugins+=("plugin-tmux")
which "todo.sh"    &>/dev/null && plugins+=("plugin-todotxt")
which "task"       &>/dev/null && plugins+=("plugin-taskwarrior")

which "ruby"       &>/dev/null && plugins+=("plugin-benchmark")

which Xorg         &>/dev/null && plugins+=("plugin-xorg")
which openbox      &>/dev/null && plugins+=("plugin-openbox")
which ratpoison    &>/dev/null && plugins+=("plugin-ratpoison")

# remove duplicates
typeset -U plugins
