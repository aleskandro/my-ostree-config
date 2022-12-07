# npm Completion {{{
if zdefault -t ':zoppo:plugin:node:npm' enable 'yes'; then
  function {
    local cache
    zdefault -s ':zoppo:plugin:node:npm' cache cache "$(path:cache)/npm.zsh"

    if is-callable npm; then
      if [[ "$commands[npm]" -nt "$cache" || ! -s "$cache" ]]; then
        npm completion >! "$cache" &> /dev/null
      fi

      source "$cache"
    fi
  }
fi
# }}}

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
