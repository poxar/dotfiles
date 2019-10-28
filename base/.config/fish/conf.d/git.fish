alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gd="git diff"
alias gl="git l"
alias gco="git checkout"

function g \
	--description "Shorthand for git interaction" \
	--wraps git
  if test (count $argv) -gt 0
    git $argv
  else
    git status --short
  end
end
