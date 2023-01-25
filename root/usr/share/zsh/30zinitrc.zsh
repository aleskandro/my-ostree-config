#!/bin/sh

[ x"$(id -u)" = x"0" ] && LOCAL_BIN_PATH=/usr/local/bin || LOCAL_BIN_PATH=~/.local/bin
LLVM_ARCH="$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')"
mkdir -p "${LOCAL_BIN_PATH}"

download_latest_gh_release() {
  if [ ${#} -lt 4 ]; then
    echo "Usage: $0 <organization> <repo> <asset-to-download-regexp> <destination>"
    return 1
  fi
  url=$(curl "https://api.github.com/repos/$1/$2/releases/latest" | jq -r '.assets | .[] | select(.name|test("'"$3"'")) | .browser_download_url')
  wget -qO "$4" "$url"
}

exists_or_install_latest_gh_release() {
  if [ "${#}" -lt 4 ]; then
    echo "Usage: $0 <organization> <repo> <asset-to-download-regexp> <destination>"
    return 1
  fi
  [ -f "$4" ] && return 0
  download_latest_gh_release "${@}"
  chmod +x "$4"
}

exists_or_extract_latest_gh_release() {
  if [ "${#}" -lt 4 ]; then
    echo "Usage: $0 <destination> <organization> <repo> <asset-to-download-regexp>"
    return 1
  fi
  destination=$1
  shift
  [ -f "$destination" ] && return 0
  download_latest_gh_release "${@}" - | tar -C "${LOCAL_BIN_PATH}" -xvzf - "$(basename "$destination")"
  chmod +x "$destination"
}

exists_or_install_http() {
  [ -f "$1" ] && return 0
  wget -qO "$1" "$2"
  chmod +x "$1"
}

exists_or_install_http "${LOCAL_BIN_PATH}/docker-machine-driver-kvm2" \
  "https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2"
exists_or_install_http "${LOCAL_BIN_PATH}"/minikube \
  "https://storage.googleapis.com/minikube/releases/latest/minikube-${LLVM_ARCH}"
exists_or_install_latest_gh_release docker compose ".*linux.*$(uname -m)$" "${LOCAL_BIN_PATH}"/docker-compose
exists_or_install_latest_gh_release mikefarah yq "linux.*$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')$" "${LOCAL_BIN_PATH}"/yq
exists_or_install_latest_gh_release 1player host-spawn "-$(uname -m)" ${LOCAL_BIN_PATH}/host-spawn
exists_or_extract_latest_gh_release "${LOCAL_BIN_PATH}/oc" okd-project okd \
  "client-linux$(uname -m | sed 's/x86_64/-/;s/aarch64/-arm64-/')4";
exists_or_extract_latest_gh_release "${LOCAL_BIN_PATH}/dive" wagoodman dive "linux_${LLVM_ARCH}.tar.gz"
exists_or_extract_latest_gh_release "${LOCAL_BIN_PATH}/chroma" alecthomas chroma "linux-${LLVM_ARCH}.tar.gz"
exists_or_install_latest_gh_release operator-framework operator-sdk "operator-sdk_linux_${LLVM_ARCH}" ${LOCAL_BIN_PATH}/operator-sdk

[ -f "${LOCAL_BIN_PATH}"/helm ] || {
  export HELM_INSTALL_DIR="${LOCAL_BIN_PATH}"
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

[ -d ~/.ohmyzsh ] && \
  find ~/.ohmyzsh/ -type f | while IFS= read -r f; do
    # shellcheck disable=SC1090
    . "$f"
  done
