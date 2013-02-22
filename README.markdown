
## What?

My public configuration-files and personal scripts. They might not work for
you, but feel free to steal from them.

I change those files a lot and sometimes I break things, so be careful.

My [vim config](https://github.com/herrblau/vimfiles) lives in in a separate
repository, so I can use it without having to fetch all of my dotfiles.

## ZSH

My zsh configuration is organised in three folders:

* **zsh/core:** basic zsh configuration like completion and prompt
* **zsh/fpath:** completion functions
* **zsh/plugin:** functions and aliases organised by topics

And into three files, that are linked into $HOME

* **zshrc** sets shell options and loads the files in proper order
* **zlogin** configures keychain and links stuff to /tmp
* **zlogout** clears the screen when logging out

## Install

Make sure you have zsh and git installed and in your $PATH.

```sh
cd ~
git clone git://github.com/herrblau/dotfiles.git .dotfiles
.dotfiles/deploy
```

If you want to deploy the big version with vim:

```sh
.dotfiles/deploy -a
```

If you want to overwrite your old files try ```.dotfiles/deploy -fi```.

However I recommend you cook up your own zsh configuration (maybe using this as
a starting point) or clone something like
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).

