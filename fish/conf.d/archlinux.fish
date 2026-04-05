if command -q pacman
  abbr -ag mp makepkg -rs
  abbr -ag p sudo pacman
  abbr -ag pi sudo pacman -S
  abbr -ag pd sudo pacman -Rs
  abbr -ag pu sudo pacman -Syu
end
