command -q nvim; and set -xg MANPAGER 'nvim +Man!'

function manwidth --on-event fish_preexec
  if string match -q -- 'man*' $argv[1]
    if test (tput cols) -gt 80
      set -gx MANWIDTH 80
    else
      set -e MANWIDTH
    end
  end
end
