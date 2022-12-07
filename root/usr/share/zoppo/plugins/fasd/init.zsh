if ! source-relative 'external/fasd' || ! is-callable fasd; then
  return 1
fi

zdefault -s ':zoppo:plugin:fasd' path _FASD_DATA "$(path:cache)/fasd"
zdefault -a ':zoppo:plugin:fasd' blacklist _FASD_BLACKLIST '--help'
zdefault -a ':zoppo:plugin:fasd' shift _FASD_SHIFT 'sudo' 'busybox'
zdefault -a ':zoppo:plugin:fasd' ignore _FASD_IGNORE 'fasd' 'ls' 'echo'
zdefault -s ':zoppo:plugin:fasd' max _FASD_MAX 2000
zdefault -a ':zoppo:plugin:fasd' backends _FASD_BACKENDS 'native'
zdefault -s ':zoppo:plugin:fasd' fuzzy _FASD_FUZZY 2

function fasd:init {
  eval "$(fasd --init zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install posix-alias)"
}

hooks:add zoppo_postinit fasd:init

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
