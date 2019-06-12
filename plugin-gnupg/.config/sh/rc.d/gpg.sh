GPG_TTY=$(tty)
export GPG_TTY

# Use gpg agent as ssh agent
unset SSH_AGENT_PID
SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export SSH_AUTH_SOCK

# Use data home for gnupg
export GNUPGHOME=${XDG_DATA_HOME:-$HOME/.local/share}/gnupg
