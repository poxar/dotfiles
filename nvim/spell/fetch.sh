#!/bin/sh
set -eu

cd "$(dirname "$0")"

test -f de.utf-8.spl || curl -O http://ftp.vim.org/vim/runtime/spell/de.utf-8.spl
test -f de.utf-8.sug || curl -O http://ftp.vim.org/vim/runtime/spell/de.utf-8.sug
test -f de.latin1.spl || curl -O http://ftp.vim.org/vim/runtime/spell/de.latin1.spl
test -f de.latin1.sug || curl -O http://ftp.vim.org/vim/runtime/spell/de.latin1.sug
