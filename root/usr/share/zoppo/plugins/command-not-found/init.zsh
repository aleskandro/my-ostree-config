plugins:load-if-enabled 'utility'

if zdefault -t ':zoppo:plugin:command-not-found' no-correct 'no'; then
  options:disable correct
  options:disable correct-all
fi

if [[ -s '/etc/zsh_command_not_found' ]]; then
  source '/etc/zsh_command_not_found'
elif [[ -s '/usr/share/doc/pkgfile/command-not-found.zsh' ]]; then
  source '/usr/share/doc/pkgfile/command-not-found.zsh'
else
  return 1
fi

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
