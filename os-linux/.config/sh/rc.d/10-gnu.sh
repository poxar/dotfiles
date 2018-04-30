# be colorful
eval $(dircolors -b)

ls_options="--color=auto $ls_options"
grep_options="--color=auto $grep_options"

# create backup files
VERSION_CONTROL='existing'
export VERSION_CONTROL

SIMPLE_BACKUP_SUFFIX='.backup'
export SIMPLE_BACKUP_SUFFIX

cp_options="-b $cp_options"
mv_options="-b $mv_options"

alias df="df -hT -x tmpfs -x devtmpfs"
alias bc="bc -ql"
