DOTFILES := $(shell pwd)

CLI    := .atoolrc .tmux.conf .ctags
CLI    += .zshrc .zlogin .zlogout .cvsignore
GIT    := .gitconfig .tigrc
XFILES := .xinitrc .urlview .Xresources .xbindkeysrc
XFILES += .ratpoisonrc .pentadactylrc .config/user-dirs.dirs
XFILES += .tmux-attach-or-new.conf

BIN    := $(addprefix ${HOME}/bin/, $(notdir $(wildcard bin/*)))
GIT    := $(addprefix ${HOME}/, $(GIT))
CLI    := $(addprefix ${HOME}/, $(CLI))
XFILES := $(addprefix ${HOME}/, $(XFILES))

all:  bin cli git xorg autoenv
full: all vim

bin:     ${HOME}/bin $(BIN)
cli:     ${HOME}/.config $(CLI)
git:     $(GIT)
xorg:    ${HOME}/.config $(XFILES)
autoenv: ${HOME}/.autoenv
vim:     ${HOME}/.vim

${HOME}/bin:
	mkdir ${HOME}/bin

${HOME}/bin/%: $(DOTFILES)/bin/%
	ln -fns $< $@

${HOME}/.config:
	mkdir ${HOME}/.config

${HOME}/.autoenv:
	git clone https://github.com/sharat87/autoenv ${HOME}/.autoenv

${HOME}/.vim:
	git clone https://github.com/herrblau/vimfiles.git ${HOME}/.vim
	cd ${HOME}/.vim && make

${HOME}/.%: $(DOTFILES)/_%
	ln -fns $< $@

clean:
	rm -f $(BIN) $(GIT) $(CLI) $(XFILES)

cleanall: clean
	cd ${HOME}/.vim && make clean
	rm -rf ${HOME}/.vim

.PHONY: all full bin autoenv vim cli git xorg clean cleanall
