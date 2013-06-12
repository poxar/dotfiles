
#
# .zlogin
#

if [[ -f ~/.notes ]]
then
  echo "\nNotes:"
  cat ~/.notes
fi

# empty line after last login message
echo ""

# start ssh-agent and gpg-agent
which keychain &>/dev/null &&
  eval `keychain -q --eval`

[[ -a $HOME/.zlogin.local ]] &&
  source $HOME/.zlogin.local
