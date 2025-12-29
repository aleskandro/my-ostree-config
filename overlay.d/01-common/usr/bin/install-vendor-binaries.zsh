#!/usr/bin/zsh

set -e

[ "$(id -u)" = "0" ] && LOCAL_BIN_PATH=/usr/local/bin || LOCAL_BIN_PATH=~/.local/bin
LLVM_ARCH="$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')"
mkdir -p "${LOCAL_BIN_PATH}"

exists_or_install_latest_gh_release docker compose ".*linux.*$(uname -m)$" "${LOCAL_BIN_PATH}"/docker-compose
exists_or_install_latest_gh_release mikefarah yq "linux.*$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')$" "${LOCAL_BIN_PATH}"/yq
exists_or_extract_latest_gh_release "${LOCAL_BIN_PATH}/oc" okd-project okd \
  "client-linux$(uname -m | sed 's/x86_64/-/;s/aarch64/-arm64-/')4";
exists_or_extract_latest_gh_release "${LOCAL_BIN_PATH}/dive" wagoodman dive "linux_${LLVM_ARCH}.tar.gz"
exists_or_extract_latest_gh_release "${LOCAL_BIN_PATH}/chroma" alecthomas chroma "linux-${LLVM_ARCH}.tar.gz"
exists_or_install_latest_gh_release operator-framework operator-sdk "operator-sdk_linux_${LLVM_ARCH}" "${LOCAL_BIN_PATH}/operator-sdk"
exists_or_extract_latest_gh_release ${LOCAL_BIN_PATH}/k9s derailed k9s "k9s_Linux_${LLVM_ARCH}.tar.gz\$"

# https://github.com/helmfile/helmfile/releases/download/v1.1.7/helmfile_1.1.7_linux_amd64.tar.gz
exists_or_extract_latest_gh_release "${LOCAL_BIN_PATH}/helmfile" helmfile helmfile "linux_${LLVM_ARCH}.tar.gz"

# symbolic link for kubectl -> oc
[ -f "${LOCAL_BIN_PATH}"/kubectl ] || ln -s "${LOCAL_BIN_PATH}/oc" "${LOCAL_BIN_PATH}/kubectl"

[ -f "${LOCAL_BIN_PATH}"/helm ] || {
  export HELM_INSTALL_DIR="${LOCAL_BIN_PATH}"
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}
