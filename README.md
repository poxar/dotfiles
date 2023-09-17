# A dotfile repo

My public configuration files and personal scripts. I change those files a lot
and sometimes I break things, so be careful.

The second half of my configuration (installed programs and such) live in my
[nixfiles](https://github.com/poxar/nixfiles). I've decided against
home-manager for now, being able to quickly change my dotfiles is preferrable
to me for now.

# Structure

I made a fresh start in 2022 to only track .config, and I did not carry the
history over, check out the
[main_2022-03-12](https://github.com/poxar/dotfiles/tree/main_2022-03-12)
branch if you're interested in my old approach.

# Installation

Stow is used to manage the symlinks. Since most tools respect the XDG base
directory spec now, it's just a matter of `stow -S .`, but traditional dotfiles
could also be tracked with a little restructuring.

To deal with ssh I have a `$HOME/.ssh/config` along these lines:

```
Include ~/.config/ssh/defaults

Host xyz
  Port 1337
  Compression yes

…
```
