DOTFILES := $(shell pwd)
BINFILES = $(shell find bin -type f | sed "s_.*/_${HOME}/bin/_")

.PHONY: all novim bin

all: bin cli autoenv git X
full: all vim

bin: dirs $(BINFILES)

${HOME}/bin/%: $(DOTFILES)/bin/%
	ln -fns $< $@

cli: dirs zsh
	ln -fns $(DOTFILES)/_tmux.conf ${HOME}/.tmux.conf
	ln -fns $(DOTFILES)/config/cower ${HOME}/.config/cower

dirs:
	mkdir -p ${HOME}/.config
	mkdir -p ${HOME}/bin

zsh:
	ln -fns $(DOTFILES)/_zshrc ${HOME}/.zshrc
	ln -fns $(DOTFILES)/_zlogin ${HOME}/.zlogin
	ln -fns $(DOTFILES)/_zlogout ${HOME}/.zlogout

autoenv:
	git clone git://github.com/kennethreitz/autoenv.git ${HOME}/.autoenv

git:
	ln -fns $(DOTFILES)/_tigrc ${HOME}/.tigrc
	ln -fns $(DOTFILES)/_gitconfig ${HOME}/.gitconfig

X: dirs
	ln -fns $(DOTFILES)/_xinitrc ${HOME}/.xinitrc
	ln -fns $(DOTFILES)/_Xresources ${HOME}/.Xresources
	ln -fns $(DOTFILES)/_xbindkeysrc ${HOME}/.xbindkeysrc
	ln -fns $(DOTFILES)/_pentadactylrc ${HOME}/.pentadactylrc
	ln -fns $(DOTFILES)/config/user-dirs.dirs ${HOME}/.config/user-dirs.dirs
	ln -fns $(DOTFILES)/_tmux-attach-or-new.conf ${HOME}/.tmux-attach-or-new.conf

vim:
	git clone https://github.com/herrblau/vimfiles.git ${HOME}/.vim
	cd ${HOME}/.vim && make
