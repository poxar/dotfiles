
## What?

My public configuration-files and personal scripts. They might not work for
you, but feel free to steal from them.

I change those files a lot and sometimes I break things, so be careful.

My [vim config](https://github.com/poxar/vimfiles) lives in in a separate
repository, so I can use it without having to fetch all of my dotfiles.

## How?

I use [GNU Stow](http://www.gnu.org/software/stow/ "GNU Stow") to link the
files in place. This pulls another dependency, but it's easy and effective, so
meh.

Every folder in this repo is a *preset* or *topic* and represents the
configuration for a program or a suite of programs. The files in those presets
are simply linked into `$HOME` as they are. Stow tries to be smart about
"folding", that means creating subdirectories instead of linking them, if
necessary. So if you want to place files into a subdirectory, but not under
version control remove the symlink, create the folder and relink (call make
again).

Presets are only installed, if the appropriate executable exists.
This cuts down on guards in the actual dotfiles (and thus may or may not speed
up some things, a little bit). Even better it lets me easily disable some
settings.

## ZSH

Everything in `$HOME/.zsh.d` will be sourced, so it's rather easy to add
functionality to zsh, or manipulate the environment.

`$HOME/.zpath` is for custom completion scripts and shell functions.

Files are sourced in alphanumeric order, so you can force a certain order by
prefixing numbers to the filenames.

## Install

Make sure you have zsh, git and stow installed and in your `$PATH`.

```sh
cd ~
git clone git://github.com/poxar/dotfiles.git .dotfiles
zsh .dotfiles/bootstrap small
```

Note, that no old files will be overwritten. That means you have to move them
away by hand. (You'll get a warning about that.)

If you want to my vim configuration and syntax highlighting in zsh:

```sh
zsh .dotfiles/bootstrap medium
```

This will pull my vim configuration from GitHub.
Again you will have to move your vim configuration away for this to work.

Finally, if you also want my X11 and WM configuration files, call

```sh
zsh .dotfiles/bootstrap huge
```

To get rid of the symlinks again, type this

```sh
zsh .dotfiles/bootstrap clean -r
```

## Using this verbatim

Don't.

Seriously, bad idea.

I recommend you cook up your own zsh configuration or clone something like
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), [dotphiles](https://github.com/dotphiles/dotphiles) or the [grml-zsh-config](http://grml.org/zsh/).

