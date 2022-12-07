plugins:require 'editor' || return 1
plugins:require 'history' || return 1

plugins:load-if-enabled 'syntax-highlight'

source-relative 'external/zsh-history-substring-search.zsh'

# Options {{{
if zstyle -t ':zoppo:plugin:history-substring-search' case-sensitive; then
  unset HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS
fi

if ! zstyle -t ':zoppo:plugin:history-substring-search' color; then
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_{FOUND,NOT_FOUND}
else
  if ! zstyle -T ':zoppo:plugin:history-substring-search:colors' found; then
    zstyle -s ':zoppo:plugin:history-substring-search:colors' found \
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
  fi

  if ! zstyle -T ':zoppo:plugin:history-substring-search:colors' not-found; then
    zstyle -s ':zoppo:plugin:history-substring-search:colors' not-found \
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
  fi
fi
# }}}

# Key Bindings {{{

for mode in 'emacs' 'vi:insert'; do
  editor:${mode}:bind 'Up' history-substring-search-up
  editor:${mode}:bind 'Down' history-substring-search-down

  editor:${mode}:bind 'PageUp' history-substring-search-up
  editor:${mode}:bind 'PageDown' history-substring-search-down
done
unset mode

# EMACS {{{
editor:emacs:bind 'Control+P' history-substring-search-up
editor:emacs:bind 'Control+N' history-substring-search-down
# }}}

# vi {{{
editor:vi:normal:bind 'k' history-substring-search-up
editor:vi:normal:bind 'j' history-substring-search-down
# }}}

# }}}

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
