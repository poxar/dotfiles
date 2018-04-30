GPG_TTY=$(tty)
export GPG_TTY

# Use gpg agent as ssh agent
unset SSH_AGENT_PID
SSH_AUTH_SOCK=$(gpgconf --list-dirs | grep agent-ssh-socket | cut -d : -f 2)
export SSH_AUTH_SOCK
