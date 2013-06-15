
## What?

My public configuration-files and personal scripts. They might not work for
you, but feel free to steal from them.

I change those files a lot and sometimes I break things, so be careful.

My [vim config](https://github.com/poxar/vimfiles) lives in in a separate
repository, so I can use it without having to fetch all of my dotfiles
(maybe Windows©, don't ask).

## How?

I use [GNU Stow](http://www.gnu.org/software/stow/ "GNU Stow") to link the
files in place. This pulls another dependency, but it's easy and effective, so
meh.

Every folder in this repo is a *preset*. The files in those presets are simply
linked into `$HOME` as they are (subdirectories are created).

The dotfiles for a certain machine are then a combination of some presets.

This cuts down on guards in the actual dotfiles (and thus may or may not speed
up some things, a little bit). Even better it lets me easily disable some
settings (right now most of my stuff simply lies in base, but that might
change).

I might add a single preset for every application in the future, so maybe I can
link my dotfiles as soon as I install some application (and unlink them when
uninstalling). However part of me thinks, this would be even worse than now,
part of me thinks that would be the best thing ever (TM).

The advantage of the current scheme is, that I can just drop new dotfiles in
some preset and be done with it. Whereas having a folder for every application,
I'd have to edit the Makefile every time.

## ZSH

Everything in `$HOME/.zsh` will be sourced, so it's rather easy to add
functionality to zsh, or manipulate the environment.

`$HOME/.fpath` is for completion scripts (\_name-of-your-executable).

Since order in the zsh configuration is really important some files are
prepended with numbers.

* **00-09** operation-system specifics (is this a GNU-system or BSD, or what?).
* **10-19** basic configuration of zsh.
* **20-29** machine specific configuration of zsh.
* **30-49** unused
* **50-59** basic aliases, and functions, that may be used anywhere else.
* **no-number** everything else

## Deployment

I use make for deployment. It helps with dependency-management and external
stuff, and I can define certain configuration-sets I use rather often.

When something changes I can simply run make again, and stow takes care of
relinking and cleaning of dead links.

## Install

Make sure you have zsh, git and stow installed and in your `$PATH`.

```sh
cd ~
git clone git://github.com/herrblau/dotfiles.git .dotfiles
cd .dotfiles
make base
```

Note, that no old files will be overwritten. That means you have to move them
away by hand.

If you want to deploy with vim:

```sh
cd ~
git clone git://github.com/herrblau/dotfiles.git .dotfiles
cd .dotfiles
make base vim
```

This will pull my vim configuration from GitHub.
Again you will have to move your vim configuration away for this to work (or
call `make cleanall`).

There are more options than those, just read through the Makefile.

## Using this verbatim

Don't.

Seriously, bad idea.

I recommend you cook up your own zsh configuration or clone something like
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) or the
[grml-zsh-config](http://grml.org/zsh/).

