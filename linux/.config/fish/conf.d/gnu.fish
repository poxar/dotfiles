set -gx VERSION_CONTROL 'existing'
set -gx SIMPLE_BACKUP_SUFFIX '.backup'

# create backups when overwriting files
alias cp="cp -b"
alias mv="mv -b"

alias df="df -hT -x tmpfs -x devtmpfs"
alias bc="bc -ql"
