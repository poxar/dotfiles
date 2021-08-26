abbr -ag ga git add
abbr -ag gc git commit
abbr -ag gca git commit --amend
abbr -ag gP git push
abbr -ag gp git pull
abbr -ag gd git diff
abbr -ag gdw git diff --word-diff --color-words
abbr -ag gdo git diff origin
abbr -ag gl git l
abbr -ag gco git checkout
abbr -ag gbr git branch
abbr -ag gf git fetch
abbr -ag gfo git fetch origin
abbr -ag gr git rebase
abbr -ag gri git rebase -i

# new style checkout
abbr -ag gs git switch
abbr -ag grs git restore

function g \
	--description "Shorthand for git interaction" \
	--wraps git
  if test (count $argv) -gt 0
    git $argv
  else
    git status --short
  end
end
