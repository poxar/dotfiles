
#
# .zshenv
#

# searchpaths
export PATH="$HOME/bin:$PATH"
fpath=($HOME/.zpath $fpath)

export GPG_TTY=$(tty)

# configuration directories
ZSHRCD=$HOME/.zshrc.d
ZLOGIND=$HOME/.zlogin.d
ZLOGOUTD=$HOME/.zlogout.d

HELPDIR=$HOME/.zhelp

