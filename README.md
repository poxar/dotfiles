# A dotfile repo

My configuration files, scripts, and random hacks. I change those files a lot
and sometimes I break things, so be careful.

Since most tools respect the XDG base directory spec now, I only track
~/.config here.

To deal with SSH I just `Include ~/.config/ssh/defaults` in `~/.ssh/config`,
most of the ssh config needs to stay private anyways, so it works out nicely.

# Installation

Stow is used to manage the symlinks and it's just a matter of `stow -S .`, see
`.stowrc` for details.

# Archive

- DWM [coastline](https://codeberg.org/poxar/dotfiles/src/branch/coastline)
- Hyprland [2025](https://codeberg.org/poxar/dotfiles/src/branch/hyprland-2025)
- Niri [2025](https://codeberg.org/poxar/dotfiles/src/branch/niri-2025)
- [Old](https://codeberg.org/poxar/dotfiles/src/branch/main_2022-03-12)
