# RVM {{{
if zdefault -t ':zoppo:plugin:ruby:rvm' enable 'no'; then
  function {
    local script
    zdefault -s ':zoppo:plugin:ruby:rvm' path script "$HOME/.rvm/scripts/rvm"

    # warn if auto-name-dirs is enabled and disable it
    if options:is-enabled 'auto-name-dirs'; then
      warn 'zoppo: RVM does not work with auto-name-dirs enabled, disabling'

      options:disable 'auto-name-dirs'
    fi

    source "$script"
  }
fi
# }}}

# rbenv {{{
if zdefault -t ':zoppo:plugin:ruby:rbenv' enable 'no'; then
  function {
    local binary
    zdefault -s ':zoppo:plugin:ruby:rbenv' path binary "$HOME/.rbenv/bin/rbenv"

    if [[ -x "$binary" ]]; then
      path=("$(dirname "$binary")" $path)
    fi

    if is-callable rbenv; then
      eval "$(rbenv init - zsh)"
    fi
  }
fi
# }}}

function {
  local GPATH
  typeset -ga path

  if (( $+commands[ruby] )); then
    ruby -rrubygems -e 'puts Gem.path' | \
      while read GPATH; do
        path+=("$GPATH/bin")
      done
    path=($^path(N-/))
  fi
}

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
