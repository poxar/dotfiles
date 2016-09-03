unset SSH_AGENT_PID
# export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
# if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
#   eval $(gpg-agent --daemon)
# fi
