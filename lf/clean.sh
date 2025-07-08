#!/bin/sh
set -eu

exec kitten icat --clear --stdin no --transfer-mode memory </dev/null >/dev/tty
