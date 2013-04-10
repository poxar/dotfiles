
#
# .zsh/plugin/notes.zsh
# note taking inspired by notational velocity
#

NOTEDIR=${NOTEDIR:-"$HOME/.notes"}
NOTEARGS+=('+set ft=markdown')
NOTEARGS+=('+set fdm=syntax')

# open note or make new one
n() { $EDITOR $EDITORARGS $NOTEARGS $NOTEDIR/"$*" }
compdef "_path_files -W $NOTEDIR" n

# list notes or search for title
if which tree &>/dev/null; then
    nls() { tree -DCt --noreport $NOTEDIR | grep "$*" }
else
    nls() { ls $ls_options -t $NOTEDIR | grep "$*" }
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
