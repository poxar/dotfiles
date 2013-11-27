
#
# .zshrc.d/tauron-mount
# mount shortcuts for NAS tauron
#

function mount-tauron() {
  udevil mount -o credentials=/home/philipp/.smbcred-tauron smb://pmi@tauron/$1
}

compctl -k "(pmi public backup download configuration)" mount-tauron
