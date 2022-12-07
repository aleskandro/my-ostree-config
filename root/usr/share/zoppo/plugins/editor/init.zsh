if terminal:is-dumb; then
  return 1
fi

# set wordchars
zdefault -s ':zoppo:plugin:editor' wordchars WORDCHARS '*?_-.[]~&;!#$%^(){}<>'

editor:keys:load
editor:load edit-command-line
editor:load self-insert url-quote-magic

# Editor Information {{{
function editor-info {
  unset editor_info
  typeset -gA editor_info

  editor_info[keymap]="$KEYMAP"
  editor_info[state]="$ZLE_STATE"

  zle reset-prompt
  zle -R
}
zle -N editor-info

# Ensures that $terminfo values are valid and updates editor information when
# the keymap changes.
function zle-keymap-select zle-line-init zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( $+terminfo[smkx] && $+terminfo[rmkx] )); then
    case "$WIDGET" in
      (zle-line-init)
        # Enable terminal application mode.
        echoti smkx
      ;;

      (zle-line-finish)
        # Disable terminal application mode.
        echoti rmkx
      ;;
    esac
  fi

  zle editor-info
}
zle -N zle-keymap-select
zle -N zle-line-finish
zle -N zle-line-init

# Toggles emacs overwrite mode and updates editor information.
function overwrite-mode {
  zle .overwrite-mode
  zle editor-info
}
zle -N overwrite-mode

# Enters vi insert mode and updates editor information.
function vi-insert {
  zle .vi-insert
  zle editor-info
}
zle -N vi-insert

# Moves to the first non-blank character then enters vi insert mode and updates
# editor information.
function vi-insert-bol {
  zle .vi-insert-bol
  zle editor-info
}
zle -N vi-insert-bol

# Enters vi replace mode and updates editor information.
function vi-replace  {
  zle .vi-replace
  zle editor-info
}
zle -N vi-replace
# }}}

# Key Bindings {{{
bindkey -d # reset the bindings to defaults

for mode ('emacs' 'vi:insert'); do
  editor:${mode}:bind 'Insert' overwrite-mode
  editor:${mode}:bind 'Delete' delete-char
  editor:${mode}:bind 'Backspace' backward-delete-char

  if zdefault -t ':zoppo:plugin:editor' dot-expansion 'yes'; then
    editor:${mode}:bind '.' expand-dot-to-parent-directory-realpath
  fi
done
unset mode

for mode ('emacs' 'vi:insert' 'vi:normal'); do
  editor:${mode}:bind 'Home' beginning-of-line
  editor:${mode}:bind 'End' end-of-line

  editor:${mode}:bind 'Left' backward-char
  editor:${mode}:bind 'Right' forward-char

  editor:${mode}:bind 'Up' up-line-or-history
  editor:${mode}:bind 'Down' down-line-or-history

  editor:${mode}:bind 'PageUp' up-line-or-history
  editor:${mode}:bind 'PageDown' down-line-or-history

  # bind <S-Tab> to go to the previous menu item
  editor:${mode}:bind 'BackTab' reverse-menu-complete
done
unset mode

# EMACS {{{
for key in 'Alt+'{B,b}
  editor:emacs:bind "$key" emacs-backward-word
unset key

for key in 'Alt+'{F,f}
  editor:emacs:bind "$key" emacs-forward-word
unset key

editor:emacs:bind Alt+Left emacs-backward-word
editor:emacs:bind Alt+Right emacs-forward-word

# kill to the beginning of the line
for key in 'Alt+'{K,k}
  editor:emacs:bind "$key" backward-kill-line
unset key

editor:emacs:bind 'Alt+_' redo

# search previous character
editor:emacs:bind 'Control+X Control+B' vi-find-prev-char

# match bracket
editor:emacs:bind 'Control+X Control+]' vi-match-bracket

# edit command in an external editor
editor:emacs:bind 'Control+X Control+E' edit-command-line

if editor:is-loaded history-incremental-pattern-search-backward; then
  editor:emacs:bind 'Control+R' history-incremental-pattern-search-backward
  editor:emacs:bind 'Control+S' history-incremental-pattern-search-forward
else
  editor:emacs:bind 'Control+R' history-incremental-search-backward
  editor:emacs:bind 'Control+S' history-incremental-search-forward
fi

# Dumb Terminals {{{
if zdefault -t ':zoppo:plugin:editor' dumb 'yes'; then
  editor:emacs:bind "^[[H" beginning-of-line
  editor:emacs:bind "^[[1~" beginning-of-line
  editor:emacs:bind "^[OH" beginning-of-line

  editor:emacs:bind "^[[F"  end-of-line
  editor:emacs:bind "^[[4~" end-of-line
  editor:emacs:bind "^[OF" end-of-line

  editor:emacs:bind '^?' backward-delete-char
  editor:emacs:bind "^[[3~" delete-char
  editor:emacs:bind "^[3;5~" delete-char
  editor:emacs:bind "\e[3~" delete-char

  editor:emacs:bind '^[[5D' emacs-backward-word
  editor:emacs:bind '^[[5C' emacs-forward-word
  editor:emacs:bind ';5D' emacs-backward-word
  editor:emacs:bind ';5C' emacs-forward-word
  editor:emacs:bind '^[[1;3D' emacs-backward-word
  editor:emacs:bind '^[[1;3C' emacs-forward-word
  editor:emacs:bind '^[[1;5D' emacs-backward-word
  editor:emacs:bind '^[[1;5C' emacs-forward-word
fi
# }}}

# }}}

# vi {{{
# edit command in an external editor.
editor:vi:normal:bind 'v' edit-command-line

# undo/redo
editor:vi:normal:bind 'u' undo
editor:vi:normal:bind 'Control+R' redo

if editor:is-loaded history-incremental-pattern-search-backward; then
  editor:vi:normal:bind '?' history-incremental-pattern-search-backward
  editor:vi:normal:bind '/' history-incremental-pattern-search-forward
else
  editor:vi:normal:bind '?' history-incremental-search-backward
  editor:vi:normal:bind '/' history-incremental-search-forward
fi

# Dumb Terminals {{{
if zdefault -t ':zoppo:plugin:editor' dumb 'yes'; then
  editor:vi:insert:bind "^[[H" beginning-of-line
  editor:vi:insert:bind "^[[1~" beginning-of-line
  editor:vi:insert:bind "^[OH" beginning-of-line

  editor:vi:insert:bind "^[[F"  end-of-line
  editor:vi:insert:bind "^[[4~" end-of-line
  editor:vi:insert:bind "^[OF" end-of-line

  editor:vi:insert:bind '^?' backward-delete-char
  editor:vi:insert:bind "^[[3~" delete-char
  editor:vi:insert:bind "^[3;5~" delete-char
  editor:vi:insert:bind "\e[3~" delete-char
fi
# }}}

# }}}

# }}}

# Beep Setting {{{
if zstyle -t ':zoppo:plugin:editor' beep; then
  setopt BEEP
else
  unsetopt BEEP
fi
# }}}

# Editor Mode {{{
zdefault -s ':zoppo:plugin:editor' mode mode 'emacs'
case "$mode" in
  emacs) bindkey -e ;;
  vi|vim) bindkey -v ;;
esac
unset mode
# }}}

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
