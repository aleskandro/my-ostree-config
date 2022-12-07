if zdefault -t ':zoppo:plugin:aliases' all 'no'; then
  for program (aliases/*(:t))
    source-relative "aliases/$program"
  unset program
else
  zdefault -a ':zoppo:plugin:aliases' programs programs \
    'git' 'rsync' 'perl' 'ruby' 'python'

  for program ("$programs[@]")
    source-relative "aliases/$program" || warn "aliases: $program: program not found"
  unset program programs
fi

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
