# A dotfile repo

My public configuration files and personal scripts. I change those files a lot
and sometimes I break things, so be careful.

My [vim config](https://github.com/poxar/vimfiles) lives in a separate
repository, so I can use it without having to fetch all of my dotfiles and the
other way around. Take a look as well, if you want to understand my complete
system.

I use [GNU Stow](http://www.gnu.org/software/stow/ "GNU Stow") to link the files
in place. This pulls another dependency, but it's easy, effective, readily
available, and (compared to other dotfile managers) stable and portable.

## Supported systems

The idea is to support as much as possible on any given unixy system, while
using as many advanced features as possible. This support, however, is rather
informal. I test these scripts on different systems for fun and to learn more
about them and about portable shell scripting. Not so much because I use them
productively and exercise my dotfiles to the fullest extend there.

## Structure

Every folder in this repo is a *plugin* or *topic* and represents the
configuration for a shell, a program, a suite of programs, a specific machine or
an operating system. The files in those plugins are simply linked into `$HOME`
as they are. Plugin names with whitespace characters are not supported.

Stow tries to be smart about “folding”, that means creating subdirectories
instead of linking them, if necessary. So if you want to place files into a
subdirectory, but not under version control remove the symlink, create the
folder and relink (sounds complicated, but is pretty transparent, just try it).

## Shell initialization

Every Bourne-compatible shell should just source everything ending in `.sh` in
`$XDG_CONFIG_HOME/sh/rc.d`. This sets up a basic environment, with some aliases,
functions, and configuration for everything included in the plugins.

Additionally, if the shell supports it, everything in
`$XDG_CONFIG_HOME/sh/login.d` and `$XDG_CONFIG_HOME/sh/logout.d` will be sourced
when starting and exiting a login shell respectively.

Files are sourced in alphanumeric order, so you can force a certain order by
prefixing numbers or characters to the filenames.

Files not ending in `.sh` are specific for certain types of shells.

### zsh

Additionally adds `$XDG_DATA_HOME/zsh/completion` to the `fpath`, right before
calling `compinit`. Thus everything included there can be used in the
programmable completion system (`zshcompsys(1)`).

### bash

Everything in `$XDG_DATA_HOME/bash/completion` will be sourced from
`$HOME/.bash_completion` to allow custom completions for functions/aliases/etc.

## Notable changes

These are just some examples and certainly not extensive, check out the
individual plugins for details.

### Predef

`00-predef.sh` adds some support functions to the shell configuration system:

* `_pd_check` ― Checks if a command is available on the system
* `_pd_func` ― Checks if a shell builtin or function is available
* `_pd_addpath` ― Idempotently prepends the first argument to `$PATH`

### Coreutils(ish)

* GNU coreutils will generate backup files, when overwriting files wit `cp`/`mv`.
* BSDs will instead prompt, if you want to overwrite files
* Colorize all the things! Most notably `man` will be rendered like a rainbow

### Keybindings

These only apply to supported shells (currently `zsh`, `bash`, and `mksh`).

* **sudo**: Add sudo in command position or (if supported) remove it if present
* **fixup**: Populate commandline with `sudo !!`, expand it if supported. In
    `zsh` the old commandline will just reappear after accepting the line, in
    other shells you need to yank it (`C-y`).
* **magic_dot**: Automatically expand `...` to `../..` anywhere in the
    commandline (only zsh and bash)
* **fg**: Quickly run `fg`. Again `zsh` allows us repopulate the commandline
    automatically, for other shells you need to yank (`C-y`) it back in place.
* **after_first_word**: Jump immediately after the word in command position.
    Useful if you forgot to add some flags to a command.

| action           | emacs | vi insert | vi command |
| ---------------- | ----- | --------- | ---------- |
| sudo             | `C-s` | `C-s`     | undefined  |
| fixup            | `M-s` | `C-f`     | `!!`       |
| magic_dot        | `.`   | `.`       | undefined  |
| fg               | `C-z` | `C-z`     | undefined  |
| after_first_word | `M-a` | undefined | `I`        |

If the shell supports `magic-space` (expanding history substitutions when
pressing space) it will be mapped (to `space`).

`C-p`/`C-n` will search the history with everything from the cursor to the start
of the line. `M-p`/`M-n` are bound to the old functionality (going up/down the
history).

Additionally some macros/abbreviations are defined if possible. Support differs
between shells depending if they support key timeouts. Here's a handy list:

| macro expansion    | zsh   | bash  | mksh    |
| ------------------ | ----- | ----- | ------- |
| `\| less`          | `\|l` | `\|l` | `C-\l`  |
| `\| awk`           | `\|a` | `\|a` | `C-\a`  |
| `\| grep `         | `\|g` | `\|g` | `C-\g`  |
| `\| head`          | `\|h` | `\|h` | `C-\h`  |
| `\| tail`          | `\|t` | `\|t` | `C-\t`  |
| `\| tail -f`       | `\|f` | `\|f` | `C-\f`  |
| `\| sort`          | `\|s` | `\|s` | `C-\s`  |
| `\| wc`            | `\|w` | `\|w` | `C-\w`  |
| `\| xargs `        | `\|x` | `\|x` | `C-\x`  |
| `\| clipboard`     | `\|c` | `\|c` | `C-\c`  |
| `2>/dev/null`      | `>E`  | `>E`  | `C-\e`  |
| `>/dev/null`       | `>N`  | `>N`  | `C-\n`  |
| `>/dev/null 2>&1`  | `>O`  | `>O`  | `C-\o`  |
| `\| `              |       |       | `C-\\`  |

Take a look at [zle.zsh](shell-zsh/.config/sh/rc.d/zle.zsh),
[readline.bash](shell-bash/.config/sh/rc.d/readline.bash), and
[configuration.mksh](shell-mksh/.config/sh/rc.d/configuration.mksh) for details
and shell specific binding.

### prompt

I like my prompt minimal. Only the zsh prompt is a bit more informative (path,
background jobs, git branch). Those are confined to the right prompt though and
disappear, when a command is issued. Since this is not possible with other
shells, they simply don't display these. When vi mode is supported in the shell,
we can however see the active mode directly from the prompt.

| mode       | zsh  | bash  |
| ---------- | ---- | ----- |
| emacs      | `> ` | `> `  |
| vi insert  | `> ` | `-> ` |
| vi command | `: ` | `:> ` |

The prompt also indicates if we are root (red `#`) and if (and only if) we're
on a different machine (per ssh) by displaying the hostname before the prompt.

The return status of the last command will be printed right after the command
(zsh) or before every prompt (bash) unless it is 0.

### fzf

On supported shells (currently `zsh` and `bash`), we get some nice key bindings
for [fzf](https://github.com/junegunn/fzf) (if it is installed).

* **fzf_path** Select one or multiple paths from `fzf` and insert them at the
    cursor position. Will escape each path with single quotes (`'`).
* **fzf_cd** Select one directory from `fzf` and quickly cd to it.

| function     | emacs       | vi command |
| ------------ | ----------- | ---------- |
| **fzf_path** | `M-<space>` | `<space>`  |
| **fzf_cd**   | `M-\`       | `\`        |

A convenient mnemonic for **fzf_path** is “Entering Metaspace”. Do note, that
the bindings are almost equivalent for emacs and vi insert modes, as `M-<space>`
will be interpreted as `<escape><space>` and thus run `<space>` in command mode.
The only difference is, that you'll end up in command mode for **fzf_path** when
using vi bindings.

### scp

The shell will warn you, if you issue a `scp` command, that has no colon. You
should use `cp` for copying on the local system. I added this as I routinely
forgot the colon and put something like `/` instead, thus copying files to
random locations on my machine.

### gpg

Is set up as ssh agent as well, so yubikeys can be used to store ssh keys.

## Install

Make sure you have git and stow installed.

```sh
cd ~
git clone git://github.com/poxar/dotfiles.git .dotfiles
.dotfiles/bin/up
```

Note, that no old files will be overwritten. That means you have to move them
away by hand. (You'll get an error about that.)

You can include your own or system configurations by simply copying them to
`$XDG_CONFIG_HOME/sh/rc.d`. Make sure they end in `.sh` or the appropriate
suffix for your shell.

To get rid of the symlinks again, type this

```sh
.dotfiles/bin/down
```

In case you want to select by hand what will be installed, call

```sh
stow -v plugin-base and all the plugins you want
```

or write the plugins you want int `$HOME/.dotrc.sh` like so

```sh
plugins="base and something else"
```

and call `bin/up`.

## Disclaimer

This is my personal configuration, so it's not the best choice if you want to
replace your current dotfiles with it. If you want that take a look at these:

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [bash-it](https://github.com/Bash-it/bash-it)
* [dotphiles](https://github.com/dotphiles/dotphiles)

