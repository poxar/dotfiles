
#
# .zlogin.d/caprica.zsh
#

# music player daemon
pgrep mpd &>/dev/null || mpd &>/dev/null
pgrep mpdscribble &>/dev/null || mpdscribble &>/dev/null

if [[ $EUID != 0 ]]; then
  # initialize tmp directories
  [[ -d "/tmp/macromedia"   ]] || mkdir "/tmp/macromedia"
  [[ -d "/tmp/adobe"        ]] || mkdir "/tmp/adobe"
  [[ -d "/tmp/adobe-pepper" ]] || mkdir "/tmp/adobe-pepper"
  [[ -d "/tmp/chromecache"  ]] || mkdir "/tmp/chromecache"
  # and link them
  [[ -e "$HOME/.macromedia"     ]] || ln -s "/tmp/macromedia" "$HOME/.macromedia"
  [[ -e "$HOME/.adobe"          ]] || ln -s "/tmp/adobe" "$HOME/.adobe"
  [[ -e "$HOME/.cache/chromium" ]] || ln -s "/tmp/chromecache" "$HOME/.cache/chromium"
  [[ -e "$HOME/.config/chromium/Default/Pepper Data" ]] || \
    ln -s /tmp/adobe-pepper "$HOME/.config/chromium/Default/Pepper Data"

  ff-sync &>/dev/null
fi

if which startx &>/dev/null && \
  [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]
then
   exec startx &> ~/.xlog
fi
