
#
# .zsh/notes.zsh
#

NOTEDIR=${NOTEDIR:-"$HOME/.notes"}
NOTEARGS+=('+set ft=markdown')
NOTEARGS+=('+set fdm=syntax')
NOTEARGS+=('+set autowriteall')
NOTEARGS+=('+set autoread')

# open note or make new one
n() {
    cd $NOTEDIR
    if [[ -z "$1" ]] && where fzf &>/dev/null; then
	$EDITOR $EDITORARGS $NOTEARGS $(fzf)
    else
	$EDITOR $EDITORARGS $NOTEARGS "$*"
    fi
    cd -
}
compdef "_path_files -W $NOTEDIR" n

# list notes or search for title
if which tree &>/dev/null; then
    nls() { tree -DCcr --noreport $NOTEDIR | grep "$*" }
else
    nls() { ls $ls_options -cr $NOTEDIR | grep "$*" }
fi
nl() { nls "$*" | head -n 15 }

# delete a note
nd() { rm -rf $NOTEDIR/"$*" }
compdef "_path_files -W $NOTEDIR" nd

# search content
nf() {
    if [[ -n $* ]]; then
	# to prevent grep from displaying the whole path
	cd $NOTEDIR
	grep -rni $grep_options "$*" *
	popd >/dev/null
    fi
}
