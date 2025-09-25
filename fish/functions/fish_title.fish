function fish_title
    echo $(string replace -r "^$HOME" "~" (pwd)) :: fish
end
