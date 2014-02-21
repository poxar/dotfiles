
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

Every folder in this repo is a *plugin* or *topic* and represents the
configuration for a program, a suite of programs, a specific machine or an
operating system. The files in those plugins are simply linked into `$HOME` as
they are. Stow tries to be smart about "folding", that means creating
subdirectories instead of linking them, if necessary. So if you want to place
files into a subdirectory, but not under version control remove the symlink,
create the folder and relink.

## ZSH

Everything in `$HOME/.zsh.d` will be sourced, so it's rather easy to add
functionality to zsh, or manipulate the environment. Next to every plugin in
this repository does this.

Files are sourced in alphanumeric order, so you can force a certain order by
prefixing numbers to the filenames.

`$HOME/.zpath` is for custom completion scripts and shell functions (i.e. it's
in `$fpath`).

Everything in `$HOME/.zlogin.d` will be sourced, when the shell starts.

Everything in `$HOME/.zlogout.d` will be sourced, when the shell exits.

## Install

Make sure you have zsh, git and stow installed and in your `$PATH`.

```sh
cd ~
git clone git://github.com/poxar/dotfiles.git .dotfiles
.dotfiles/bin/up
```

Note, that no old files will be overwritten. That means you have to move them
away by hand. (You'll get a warning about that.)

To get rid of the symlinks again, type this

```sh
.dotfiles/bin/down
```

In case you want to select by hand what will be installed, call

```sh
stow -v base and all the plugins you want
```

or write the plugins you want int `$HOME/.dotrc.zsh` like so

```sh
plugins=("base" "and" "something" "else")
```

and call `bin/up`.

## Using this verbatim

Don't.

Seriously, bad idea.

I recommend you cook up your own zsh configuration, but feel free to adopt my
system if you want (I might set up an example repo when I have the time). If
you're searching for a preconfigured environment take a look at

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [dotphiles](https://github.com/dotphiles/dotphiles)
* [grml-zsh-config](http://grml.org/zsh/).

