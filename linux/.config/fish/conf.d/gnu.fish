set -gx VERSION_CONTROL 'existing'
set -gx SIMPLE_BACKUP_SUFFIX '.backup'

# create backups when overwriting files
abbr -ag cp cp -b
abbr -ag mv mv -b

abbr -ag df df -hT -x tmpfs -x devtmpfs
abbr -ag bc bc -ql

abbr -ag psf "ps --ppid 2 -p 2 --deselect auf | less"
abbr -ag psg "ps aux | grep -v grep | grep -i -e '^USER' -e"

if command -q lsof
  abbr -ag ports "lsof -iTCP -sTCP:LISTEN -P"
  abbr -ag allports "netstat -tulanp"
else
  abbr -ag ports "netstat -tulanp"
end

abbr -ag nftl "sudo nft list ruleset | less"
