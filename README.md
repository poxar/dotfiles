# A dotfile repo

My public configuration files and personal scripts. I change those files a lot
and sometimes I break things, so be careful.

I might or might not be converting to nix home-manager, so some of my stuff
already lives over at [poxar/nixfiles](https://github.com/poxar/nixfiles).

# Structure

The structure has changed a lot in 2022 and I did not carry the history over,
check out the `old_main` branch if you're interested in my old approach.

My new approach is to directly track `$HOME/.config` as a repository, that way
I don't need to worry about symlinks that grow stale or copying stuff back and
forth. On the other hand, only things that adhere to the XDG Base Directory
spec can be included that way, but that's fine by me. ¯\\\_(ツ)\_/¯

To deal with ssh I have a `$HOME/.ssh/config` along these lines:

```
Include ~/.config/ssh/defaults

Host xyz
  Port 1337
  Compression yes

…
```

# Installation

If `$HOME/.config` doesn't exist yet, you're in luck:

```
git clone git@github.com:poxar/dotfiles ~/.config
```

Usually it does exist, however, in which case it's a bit more complicated:

```
cd ~
git clone git@github.com:poxar/dotfiles ~/.config_next
mv .config/* .config/.* .config_next
rmdir .config
mv .config_next .config
```

Now you can `cd .config && git diff` to see what would be overwritten and
`git restore` what you want.

# Dealing with untracked files

There are two options:

1. `git config status.showUntrackedFiles no`, but then it's hard to see new configurations
2. maintain a massive `.gitignore`

I usually opt for the second, since I like to keep track of what happens. But
`git status --untracked-files=all` is probably good enough.
