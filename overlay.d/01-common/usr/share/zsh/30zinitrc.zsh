#!/bin/sh


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

[ -d ~/.ohmyzsh ] && \
  find ~/.ohmyzsh/ -type f | while IFS= read -r f; do
    # shellcheck disable=SC1090
    . "$f"
  done
