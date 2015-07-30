export NOTEDIR=${NOTEDIR:-"$HOME/.notes"}
NOTEARGS+=('+set autowriteall')
NOTEARGS+=('+set autoread')
export NOTEARGS

alias nl="nls | head -n 15"
