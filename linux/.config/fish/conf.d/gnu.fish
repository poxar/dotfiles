set -gx VERSION_CONTROL 'existing'
set -gx SIMPLE_BACKUP_SUFFIX '.backup'

# create backups when overwriting files
abbr -ag cp cp -b
abbr -ag mv mv -b

abbr -ag df df -hT -x tmpfs -x devtmpfs
abbr -ag bc bc -ql
