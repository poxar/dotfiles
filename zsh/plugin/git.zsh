
#
# .zsh/plugin/git.zsh
#

if which git &>/dev/null; then

    alias g="git"

    alias ga="git add"
    alias garm="git add -A"
    alias gc="git commit"
    alias gca="git commit -a"

    alias gcl="git clone"
    alias gp="git push"
    alias gpu="git pull"

    alias gco="git checkout"
    alias gbr="git branch"

    alias gs="git status"
    alias gd="git diff"

    alias gundo="git reset --soft HEAD~1"

    alias gl="git l"

fi

# vim:set sw=4 foldmethod=marker ft=zsh:
