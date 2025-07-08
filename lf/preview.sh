#!/bin/sh

case "$(file -Lb --mime-type -- "$1")" in
  text/*) cat -- "$1" ;;
  application/json) jq . -- "$1" ;;
  application/gzip) bsdtar tf "$1" ;;
  application/lzop) bsdtar tf "$1" ;;
  application/lzma) bsdtar tf "$1" ;;
  application/bzip) bsdtar tf "$1" ;;
  application/xz)   bsdtar tf "$1" ;;
  application/lz4)  bsdtar tf "$1" ;;
  application/zstd) bsdtar tf "$1" ;;
  *) echo "Binary file not previewed" ;;
esac
