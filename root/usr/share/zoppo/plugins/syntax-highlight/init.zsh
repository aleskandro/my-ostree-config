# this is needed because we have to load the editor stuff before running this
# otherwise the coloring breaks (happened with url-quote-magic and self-insert)
plugins:require 'editor' || return 1

zstyle -t ':zoppo:plugin:syntax-highlight' color || return 1

source-relative 'external/zsh-syntax-highlighting.zsh'

zdefault -a ':zoppo:plugin:syntax-highlight' highlighters ZSH_HIGHLIGHT_HIGHLIGHTERS \
  'main' 'brackets' 'cursor'

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
