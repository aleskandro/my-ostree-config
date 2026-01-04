#!/usr/bin/zsh

source /etc/zshrc

[ "$(id -u)" = "0" ] && LOCAL_BIN_PATH=/usr/local/bin || LOCAL_BIN_PATH=~/.local/bin
LLVM_ARCH="$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')"
mkdir -p "${LOCAL_BIN_PATH}"

exists_or_install_latest_gh_release 1player host-spawn "-$(uname -m)" ${LOCAL_BIN_PATH}/host-spawn

# https://github.com/obsidianmd/obsidian-releases/releases/download/v1.10.6/Obsidian-1.10.6.AppImage
OBSIDIAN_ARCH_REGEX='^(?!.*-arm64).*\\.AppImage$'
if [ "$LLVM_ARCH" != "x86_64" ]; then
  OBSIDIAN_ARCH_REGEX=".*-${LLVM_ARCH}"'\\.AppImage$'
fi
exists_or_install_latest_gh_release obsidianmd obsidian-releases "$OBSIDIAN_ARCH_REGEX" "${LOCAL_BIN_PATH}/obsidian"

