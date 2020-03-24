GPG_TTY=$(tty)
export GPG_TTY

# Use data home for gnupg
export GNUPGHOME="${XDG_DATA_HOME:-"$HOME/.local/share"}/gnupg"
