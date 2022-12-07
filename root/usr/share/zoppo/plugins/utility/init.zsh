if zdefault -t ':zoppo:plugin:utility' auto-correct 'yes'; then
  options:enable 'correct'

  if ! terminal:is-dumb; then
    # so we get nice colors with auto-correction
    SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
  fi
fi

# ZSH utilities {{{
if zdefault -t ':zoppo:plugin:utility:zsh' enable 'yes'; then
  functions:autoload ztodo
  functions:autoload zed
  functions:autoload zcalc

  functions:autoload zmv
  alias zcp='zmv -C'
  alias zln='zmv -L'

  functions:autoload zargs
fi
# }}}

# GNU utilities {{{
if zdefault -t ':zoppo:plugin:utility:gnu' enable 'no'; then
  function {
    local prefix
    local -a binaries
    local cmd

    zdefault -s ':zoppo:plugin:utility:gnu' prefix prefix 'g'
    zdefault -a ':zoppo:plugin:utility:gnu' binaries binaries \
      'b2sum' 'base32' 'base64' 'basename' 'basenc' 'cat' 'chcon' 'chgrp' \
      'chmod' 'chown' 'chroot' 'cksum' 'comm' 'cp' 'csplit' 'cut' 'date' 'dd' \
      'df' 'dir' 'dircolors' 'dirname' 'du' 'echo' 'env' 'expand' 'expr' \
      'factor' 'false' 'fmt' 'fold' 'groups' 'head' 'hostid' 'id' 'install' \
      'join' 'kill' 'link' 'ln' 'logname' 'ls' 'md5sum' 'mkdir' 'mkfifo' \
      'mknod' 'mktemp' 'mv' 'nice' 'nl' 'nohup' 'nproc' 'numfmt' 'od' 'paste' \
      'pathchk' 'pinky' 'pr' 'printenv' 'printf' 'ptx' 'pwd' 'readlink' \
      'realpath' 'rm' 'rmdir' 'runcon' 'seq' 'sha1sum' 'sha224sum' 'sha256sum' \
      'sha384sum' 'sha512sum' 'shred' 'shuf' 'sleep' 'sort' 'split' 'stat' \
      'stdbuf' 'stty' 'sum' 'sync' 'tac' 'tail' 'tee' 'test' 'timeout' 'touch' \
      'tr' 'true' 'truncate' 'tsort' 'tty' 'uname' 'unexpand' 'uniq' 'unlink' \
      'uptime' 'users' 'vdir' 'wc' 'who' 'whoami' 'yes' \
      \
      'addr2line' 'ar' 'c++filt' 'elfedit' 'nm' 'objcopy' 'objdump' \
      'ranlib' 'readelf' 'size' 'strings' 'strip' \
      \
      'find' 'locate' 'oldfind' 'updatedb' 'xargs' \
      \
      'libtool' 'libtoolize' \
      \
      'getopt' 'grep' 'indent' 'sed' 'tar' 'time' 'units' 'which'

    for cmd in "$binaries[@]"; do
      if ! is-command "$prefix$cmd" || is-function "$cmd"; then
        continue
      fi

      eval "function $cmd {
        $prefix$cmd \"\$@\"
      }"
    done
  }
fi
# }}}

# ls {{{
if zstyle -t ':zoppo:plugin:utility:ls' color; then
  if ! zstyle -T ':zoppo:plugin:utility:ls' colors; then
    zstyle -s ':zoppo:plugin:utility:ls' colors LS_COLORS

    export LS_COLORS
  elif is-callable 'dircolors'; then
    if [[ -s "$HOME/.dircolors" ]]; then
      eval "$(dircolors "$HOME/.dircolors")"
    else
      eval "$(dircolors)"
    fi
  fi

  if utility:is-gnu; then
    alias+ ls '--color=auto'
  else
    alias+ ls '-G'
  fi
else
  alias+ ls '-F'
fi
# }}}

# grep {{{
if zstyle -t ':zoppo:plugin:utility:grep' color; then
  function grep {
    command grep --color=auto $@
  }

  zstyle -s ':zoppo:plugin:utility:grep' highlight-color GREP_COLOR
  zstyle -s ':zoppo:plugin:utility:grep' colors GREP_COLORS

  export GREP_COLOR GREP_COLORS
fi
# }}}

# whatis {{{
if (( $+commands[whatis] )) && zdefault -t ':zoppo' easter-egg 'true'; then
  function whatis() {
    local arg
    for arg ("$argv[@]"); do
      case "$arg" in
        [Ll][Oo][Vv][Ee])
          echo "$arg: Baby don't hurt me, don't hurt me, no more"
          ;;
        *)
          command whatis "$arg"
          ;;
      esac
    done
  }
fi
# }}}

# math {{{
if zdefault -t ':zoppo:plugin:utility:math' enable 'yes'; then
  zmodload zsh/mathfunc

  function math {
    echo $((${=@}))
  }

  alias m="noglob math"
fi
# }}}

# Disable Correction {{{
function {
  local programs
  local program

  zdefault -a ':zoppo:plugin:utility' no-correct programs \
    'ack' 'cd' 'cp' 'ebuild' 'gcc' 'gist' 'grep' 'heroku' 'ln' 'man' 'mkdir' 'mv' 'mysql' 'rm'

  for program ("$programs[@]")
    alias "$program"="nocorrect $program"
}
# }}}

# Disable Globbing {{{
function {
  local programs
  local program

  zdefault -a ':zoppo:plugin:utility' no-glob programs \
    'fc' 'find' 'ftp' 'history' 'locate' 'rake' 'rsync' 'scp' 'sftp'

  for program ("$programs[@]")
    alias "$program"="noglob $program"
}
# }}}

# Ignore From History {{{
function {
  local programs
  local program

  zdefault -a ':zoppo:plugin:utility' no-history programs \
    'poweroff' 'halt' 'reboot'

  for program ("$programs[@]")
    alias "$program"=" $program"
}
# }}}

# Enable Interactive {{{
function {
  local programs
  local program

  zdefault -a ':zoppo:plugin:utility' interactive programs \
    'cp' 'ln' 'mv' 'rm'

  for program ("$programs[@]")
    alias+ "$program" '-i'
}
# }}}

# Wrap In Readline {{{
is-callable rlwrap && function {
  local programs
  local program

  zdefault -a ':zoppo:plugin:utility' readline programs \
    'nc' 'telnet' 'sbcl' 'tclsh' 'mzscheme' 'iex' 'mix'

  for program ("$programs[@]")
    alias "$program"="rlwrap --always-readline -H '$(path:cache)/$program.history' -c -D 2 -r $program"
}
# }}}

# Directory Stuff {{{
alias+ mkdir '-p'
alias md='mkdir'

function mcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

alias mkdcd='mcd'

function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}
# }}}

# Mac OS X Everywhere {{{
if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
else
  alias o='xdg-open'
  alias get='wget --continue --progress=bar --timestamping'

  if is-callable xclip; then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif is-callable xsel; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

alias copy='pbc'
alias paste='pbp'
# }}}

# Fork {{{
zdefault ':zoppo:plugin:utility:fork' programs \
  'firefox' 'thunderbird' 'eog' 'ristretto' 'thunar' 'evince' 'vlc' 'urxvt'

if zdefault -t ':zoppo:plugin:utility:fork' enable 'yes'; then
  zstyle -a ':zoppo:plugin:utility:fork' programs programs

  for cmd ("$programs[@]"); do
    eval "function $cmd {
      fork command $cmd \"\$@\"
    }"
  done
fi
# }}}

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
