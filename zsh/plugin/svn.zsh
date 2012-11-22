
#
# .zsh/topics/svn.zsh
#

alias s="svn"

alias sa="svn add"
alias sc="svn commit"
alias sup="svn up"
alias sst="svn status"
alias sl="svn log"
alias sdi="svn diff --diff-cmd colordiff"


# find all non-executables and add them
# http://stackoverflow.com/questions/2191203/how-to-make-svn-add-ignore-binaries
function saa() {
    find $1 \( -executable -type f \) -prune -o -print | \
        xargs svn add --depth empty
}

# vim:set sw=4 foldmethod=marker ft=zsh:
