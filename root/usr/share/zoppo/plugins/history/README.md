History
=======
This plugin sets up history options and variables.

History File
------------
You can set what file to store the history at.

The default is `${ZDOTDIR:-$HOME}/.zhistory`.

    zstyle ':zoppo:plugin:history' file '/tmp/history'

History Size
------------
You can set the max live and saved history size.

The default is `10000` for both.

    zstyle ':zoppo:plugin:history' max       50000
    zstyle ':zoppo:plugin:history' max-saved 20000

History Options
---------------
You can also set history options.

    zstyle ':zoppo:plugin:history' options 'no-bang-hist' 'no-extended-history' 'save-no-dups'
