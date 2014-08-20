
#
# .zlogin.d/keychain.zsh
# start ssh-agent and gpg-agent
#

eval `keychain -q --nogui --eval id_dsa id_rsa id_ecdsa`

