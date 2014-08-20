export NOTEDIR=${NOTEDIR:-"$HOME/.notes"}
NOTEARGS+=('+set ft=markdown')
NOTEARGS+=('+set fdm=syntax')
NOTEARGS+=('+set autowriteall')
NOTEARGS+=('+set autoread')
export NOTEARGS

alias nl="nls | head -n 15"
