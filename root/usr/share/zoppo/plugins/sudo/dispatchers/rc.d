function sudo:dispatch:rc.d {
  (( $# == 0 )) && return 1

  case "$1" in
    status|list) return 1 ;;
    *) return 0 ;;
  esac
}

sudo:dispatch sudo:dispatch:rc.d rc.d

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
