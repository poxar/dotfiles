
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

    # thanks @holman for the nice format
    alias gl="git log --graph --abbrev-commit --date=relative \
    --pretty=format:'%Cred%h%Creset %an: %s -%Creset%C(yellow)%d%Creset %Cgreen(%cr)%Creset'"

fi

# vim:set sw=4 foldmethod=marker ft=zsh:
