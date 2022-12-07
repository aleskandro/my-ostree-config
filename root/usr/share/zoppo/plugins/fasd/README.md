fasd
====
[fasd][1] is a command-line productivity booster, inspired by tools like
[autojump][2], [z][3] and [v][4], it offers quick access to files and
directories by keeping track of files and directories  that were previously
accessed.

Cache Path
----------
You can set where the fasd cache resides.

The default is `$(path:cache)/fasd`.

    zstyle ':zoppo:plugin:fasd' path '/tmp/fasd'

Blacklist
---------
You can blacklist some parts of commands.

    zstyle ':zoppo:plugin:fasd' blacklist '--help'

Shift
-----
You can tell fasd to shift some parts of commands, it's especially useful with
sudo and the like.

    zstyle ':zoppo:plugin:fasd' shift 'sudo' 'busybox'

Ignore
------
You can tell fasd to ignore some commands completely.

The default is `fasd` `ls` `echo`.

    zstyle ':zoppo:plugin:fasd' ignore 'rm' 'mplayer' 'cp' 'mv'

Max
---
You can tell fasd the max total score / weight.

The default is `2000`.

    zstyle ':zoppo:plugin:fasd' max '4000'

Backends
--------
You can add backends and tell fasd which to use.

The default is `native`.

    zstyle ':zoppo:plugin:fasd' backends 'native' 'viminfo' 'recently-used.xbel'

Fuzzyness
---------
You can set the level of fuzzyness which is used to match the strings.

The default is `2`, if you set it to `0` the fuzzy matching will be disabled.

    zstyle ':zoppo:plugin:fasd' fuzzy '0'

[1]: https://github.com/clvv/fasd
[2]: https://github.com/joelthelion/autojump
[3]: https://github.com/rupa/z
[4]: https://github.com/rupa/v

