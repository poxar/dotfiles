
#
# .zsh/topics/notes.zsh
# note taking inspired by notational velocity
#

NOTEDIR=$HOME/.pim/notes
EDITORARGS=()

# open note or make new one
n() { $EDITOR $EDITORARGS $NOTEDIR/"$*" }
compdef "_path_files -W $NOTEDIR" n

# list notes or search for title
nls() { tree -DCt --noreport $NOTEDIR | grep "$*" }
nl() { nls "$*" | head -n 15 }

# delete a note
nd() { rm -rf $NOTEDIR/"$*" }
compdef "_path_files -W $NOTEDIR" nd

# search content
nf() {
    if [[ -n $* ]]; then
	# to prevent grep from displaying the whole path
	cd $NOTEDIR
	grep -rni "$*" *
	popd >/dev/null
    fi
}
