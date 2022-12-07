# Path Settings {{{
function {
  typeset -gU path manpath

  setopt LOCAL_OPTIONS EXTENDED_GLOB BARE_GLOB_QUAL

  # prepend PEP 370 per user site packages directory, which defaults to
  # ~/Library/Python on Mac OS X and ~/.local elsewhere, to PATH/MANPATH
  if [[ "$OSTYPE" == darwin* ]]; then
    path=($HOME/Library/Python/*/bin(N) $path)
    manpath=($HOME/Library/Python/*/{,share/}man(N) $manpath)
  else
    path=($HOME/.local/bin $path)
    manpath=($HOME/.local/{,share/}man(N) $manpath)
  fi
}
# }}}

# pythonz {{{
if zdefault -t ':zoppo:plugin:python:pythonz' enable 'no'; then
  function {
    local binary
    zdefault -s ':zoppo:plugin:python:pythonz' path binary "$HOME/.pythonz/bin/pythonz"

    if [[ -x $binary ]]; then
      path=("$(dirname "$binary")" $path)
    fi
  }
fi
# }}}

# virtualenv {{{
if zdefault -t ':zoppo:plugin:python:virtualenv' enable 'no'; then
  function {
    local envs
    zdefault -s ':zoppo:plugin:python:virtualenv' path envs "$HOME/.virtualenvs"

    if (( $+commands[virtualenvwrapper_lazy.sh] )); then
      export WORKON_HOME="$envs"
      export VIRTUAL_ENV_DISABLE_PROMPT=1

      source "$commands[virtualenvwrapper_lazy.sh]"
    fi
  }
fi
# }}}

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
