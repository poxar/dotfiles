prefix := ${HOME}
stow_options := -t $(prefix)

# packages
.PHONY: base desktop
base: vim
	stow $(stow_options) -R base
desktop: base
	stow $(stow_options) -R desktop


# os
.PHONY: gnu archlinux freebsd
gnu:
	stow $(stow_options) -R gnu
archlinux: gnu
	stow $(stow_options) -R archlinux
freebsd:
	stow $(stow_options) -R freebsd


# externals
.PHONY: autoenv vim

autoenv: $(prefix)/.autoenv
	stow $(stow_options) -R autoenv
$(prefix)/.autoenv:
	git clone https://github.com/sharat87/autoenv $(prefix)/.autoenv

vim: $(prefix)/.vim
	cd $(prefix)/.vim && make prefix=$(prefix)
$(prefix)/.vim:
	git clone https://github.com/poxar/vimfiles.git $(prefix)/.vim


# cleaning
.PHONY: unstow clean
unstow:
	stow $(stow_options) -D $(wildcard */)

clean: unstow
	cd $(prefix)/.vim && make clean
	rm -rf $(prefix)/.autoenv
	rm -rf $(prefix)/.vim


# machines
.PHONY: caprica helo poxar
caprica: archlinux desktop autoenv
	stow $(stow_options) -R caprica
helo:    archlinux base
poxar:   archlinux base
