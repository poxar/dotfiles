#!/bin/sh
set -eu

cd ~/Code
sleep 0.1

sel="$(fd -Is 'Session.vim' | xargs dirname | sk)"

cd "$sel"
nvim -S Session.vim
