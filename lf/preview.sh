#!/bin/sh

file="$1"
w="$2"
h="$3"
x="$4"
y="$5"

image() {
  kitten icat --clear --stdin no --transfer-mode memory --place "${w}x${h}@${x}x${y}" "$1" </dev/null >/dev/tty
  exit 1
}

case "$(file -Lb --mime-type -- "$file")" in
  text/*) head -n "$h" -- "$file" ;;
  image/*) image "$file" ;;
  application/json) jq . -- "$file" ;;
  application/x-tar) bsdtar tf "$file" ;;
  application/gzip) bsdtar tf "$file" ;;
  application/lzop) bsdtar tf "$file" ;;
  application/lzma) bsdtar tf "$file" ;;
  application/bzip) bsdtar tf "$file" ;;
  application/xz)   bsdtar tf "$file" ;;
  application/lz4)  bsdtar tf "$file" ;;
  application/zstd) bsdtar tf "$file" ;;
  *) echo "Binary file not previewed" ;;
esac
