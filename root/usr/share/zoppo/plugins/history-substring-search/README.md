History Substring Search
========================
This plugin integrates [zsh-history-substring-search][1] into *zoppo*, which
implements the [Fish shell][2]'s history search feature, where the user can
type in any part of a previously entered command and press up and down to cycle
through matching commands.

Case Sensitivity
----------------
You can enable/disable case sensitivity.

It's disabled by default.

    zstyle ':zoppo:plugin:history-substring-search' case-sensitive 'yes'

Highlighting Colors
-------------------
You can enable/disable and set colors when highlighting found or not found
matches.

    zstyle ':zoppo:plugin:history-substring-search' color 'yes'
    zstyle ':zoppo:plugin:history-substring-search:colors' found 'bg=green,fg=white,bold'
    zstyle ':zoppo:plugin:history-substring-search:colors' not-found 'bg=red,fg=white,bold'

[1]: https://github.com/zsh-users/zsh-history-substring-search
[2]: http://fishshell.com
