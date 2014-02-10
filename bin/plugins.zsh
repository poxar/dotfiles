emulate zsh

# base is required
plugins=("base")
dependencies=("less" "dfc" "ctags" "vim")

# load host specific plugins
[[ -d "$REPOSITORY/host-$HOST" ]] && plugins+=("host-$HOST")

# load os specific plugins
[[ $OSTYPE =~ ".*gnu.*" ]]     && plugins+=("os-gnu")
[[ $OSTYPE =~ ".*freebsd.*" ]] && plugins+=("os-freebsd")

# guess if other plugins should be included
which "pacman"   &>/dev/null && plugins+=("plugin-archlinux") && \
  dependencies+=("pkgfile")
which "aptitude" &>/dev/null && plugins+=("plugin-aptitude")

which "ack"      &>/dev/null && plugins+=("plugin-ack")
which "ack-grep" &>/dev/null && plugins+=("plugin-ack")
which "aunpack"  &>/dev/null && plugins+=("plugin-atool") && \
  dependencies+=("pigz" "pbzip2" "colordiff")
which "git"      &>/dev/null && plugins+=("plugin-git") && \
  dependencies+=("tig")
which "hg"       &>/dev/null && plugins+=("plugin-mercurial")
which "keychain" &>/dev/null && plugins+=("plugin-keychain")
which "svn"      &>/dev/null && plugins+=("plugin-subversion")
which "tmux"     &>/dev/null && plugins+=("plugin-tmux") && \
  dependencies+=("urlview")

# populate the extra array
which Xorg      &>/dev/null && extra+=("plugin-xorg") && \
  dependencies+=("autorandr" "xbindkeys" "openbox")
which openbox   &>/dev/null && extra+=("plugin-openbox") && \
  dependencies+=("udevedu" "nitrogen" "compton" "stalonetray" "conky" "pasystray")
which ratpoison &>/dev/null && extra+=("plugin-ratpoison") && \
  dependencies+=("udevedu" "nitrogen" "compton" "stalonetray" "conky" "pasystray")

# remove duplicates
typeset -U plugins extra
