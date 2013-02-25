
#
# .zsh/plugin/web.zsh
#

# pastebin sprunge.us (<command> | sprunge)
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

# find out own ip
alias myip="lynx -dump tnx.nl/ip"

# download album from imgur
imgur() { curl "$1" | grep _blank | awk '{print $2}' | cut -d \" -f 2 | \
    xargs wget }

