zdefault -s ':zoppo:plugin:history' file      HISTFILE "${ZDOTDIR:-$HOME}/.zhistory"
zdefault -s ':zoppo:plugin:history' max       HISTSIZE 10000
zdefault -s ':zoppo:plugin:history' max-saved SAVEHIST 10000

function {
  local -a zoptions
  local option

  zdefault -a ':zoppo:plugin:history' options zoptions \
    'bang-hist' 'extended-history' 'inc-append-history' 'share-history' 'expire-dups-first' \
    'ignore-dups' 'ignore-all-dups' 'find-no-dups' 'ignore-space' 'save-no-dups' 'verify' 'no-beep'

  for option ("$zoptions[@]"); do
    if [[ "$option" =~ "^no-" ]]; then
      if ! options:disable "hist-${${${option#no-}//-/_}:u}" && ! options:disable "${${${option#no-}//-/_}:u}"; then
        print "history: ${option#no-} not found: could not disable"
      fi
    else
      if ! options:enable "hist-${${option//-/_}:u}" && ! options:enable "${${option//-/_}:u}"; then
        print "history: $option not found: could not enable"
      fi
    fi
  done
}

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
