#!/bin/zsh

[ -d ~/.ohmyzsh ] && \
  find ~/.ohmyzsh/ -type f | while IFS= read -r f; do
    # shellcheck disable=SC1090
    . "$f"
  done
