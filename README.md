# A dotfile repo

My public configuration files and personal scripts. I change those files a lot
and sometimes I break things, so be careful.

**TL;DR** Start browsing in `base`.

My [vim configuration](https://github.com/poxar/vimfiles) lives in a separate
repository, so I can use it without having to fetch all of my dotfiles and the
other way around. Take a look as well, if you want to understand my complete
system.

I use [GNU Stow](http://www.gnu.org/software/stow/ "GNU Stow") to link the files
in place. This pulls another dependency, but it's easy, effective, readily
available, and (compared to other dotfile managers) stable and portable.

Stow tries to be smart about “folding”, that means creating subdirectories
instead of linking them, if necessary. So if you want to place files into a
subdirectory, but not under version control you'll have to remove the symlink,
create the folder and relink.

## Structure

Firstly **base** includes most of my configuration. If you're just browsing,
start there. The other folders contain configuration for specific systems and
should only be installed on the appropriate systems.

## Notable changes

These are just some examples and certainly not extensive.

### Coreutils(ish)

* GNU coreutils will generate backup files, when overwriting files wit `cp`/`mv`.
* BSDs will instead prompt, if you want to overwrite files
* Colorize all the things, this is now mostly done by fish, but additionally
  `man` will be rendered like a rainbow

### Keybindings

* **sudo** *C-s*: Add sudo in command position or remove it if present.
	If the commandline is empty it fetches the last line from history
	and does the same.
* **magic_dot**: Automatically expand `...` to `../..` anywhere in the
    commandline

### scp

The shell will warn you, if you issue a `scp` command that has no colon. You
should use `cp` for copying on the local system. I added this as I routinely
forgot the colon and put something like `/` instead, thus copying files to
random locations on my machine.

## Install

Make sure you have git and stow installed.

The following will install just the base configurations:

```sh
cd ~
git clone git://github.com/poxar/dotfiles.git .dotfiles
stow --target=$HOME base
./setup.fish
```

Note, that no old files will be overwritten. That means you have to move them
away by hand. (You'll get an error about that.) `setup.fish` however
will happily overwrite your universal variables, so use with care.

To get rid of the symlinks again, type this

```sh
stow --target=$HOME -D base
```

As a more complete example, here's how I would setup my usual notebook:

```sh
stow --target=$HOME base linux linux-archlinux
```

Or if I have to work on a Mac:

```sh
stow --target=$HOME base darwin
```

## Disclaimer

This is my personal configuration, so it's not the best choice if you want to
replace your current dotfiles with it. If you want that take a look at these:

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [bash-it](https://github.com/Bash-it/bash-it)
* [dotphiles](https://github.com/dotphiles/dotphiles)

