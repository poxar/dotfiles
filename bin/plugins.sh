# base is required
plugins="plugin-base"

# load host specific plugins
test -d "$REPOSITORY/host-$(hostname -s)" && plugins="$plugins host-$(hostname -s)"

# load shell plugins
check "bash" && plugins="$plugins shell-bash"
check "mksh" && plugins="$plugins shell-mksh"
check "zsh"  && plugins="$plugins shell-zsh"

# load os specific plugins
uname | grep -q "GNU/.*"    && plugins="$plugins os-linux"
test "$(uname)" = "Linux"   && plugins="$plugins os-linux"
test "$(uname)" = "FreeBSD" && plugins="$plugins os-freebsd"
test "$(uname)" = "Darwin"  && plugins="$plugins os-darwin"

# guess if other plugins should be included
check "pacman"    && plugins="$plugins plugin-archlinux"
check "aptitude"  && plugins="$plugins plugin-aptitude"

check "rustc"     && plugins="$plugins plugin-rust"
check "ghc"       && plugins="$plugins plugin-haskell"
check "scalac"    && plugins="$plugins plugin-scala"
check "python"    && plugins="$plugins plugin-python"
check "go"        && plugins="$plugins plugin-go"
check "npm"       && plugins="$plugins plugin-nodejs"
check "ruby"      && plugins="$plugins plugin-ruby"

check "aunpack"   && plugins="$plugins plugin-atool"
check "autossh"   && plugins="$plugins plugin-irc"
check "ccache"    && plugins="$plugins plugin-ccache"
check "ctags"     && plugins="$plugins plugin-ctags"
check "docker"    && plugins="$plugins plugin-docker"
check "fd"        && plugins="$plugins plugin-fd"
check "fzf"       && plugins="$plugins plugin-fzf"
check "git"       && plugins="$plugins plugin-git"
check "gpg"       && plugins="$plugins plugin-gnupg"
check "hg"        && plugins="$plugins plugin-mercurial"
check "lsof"      && plugins="$plugins plugin-lsof"
check "pass"      && plugins="$plugins plugin-pass"
check "qemu"      && plugins="$plugins plugin-qemu"
check "qiv"       && plugins="$plugins plugin-qiv"
check "ruby"      && plugins="$plugins plugin-benchmark"
check "scanimage" && plugins="$plugins plugin-sane"
check "ssh"       && plugins="$plugins plugin-ssh"
check "tcplay"    && plugins="$plugins plugin-tcplay"
check "tmux"      && plugins="$plugins plugin-tmux"

true
