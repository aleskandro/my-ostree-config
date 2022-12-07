Completion
==========
Loads and configures tab completion and provides additional completions from
the [zsh-completions][1] project.

Completion Options
------------------
You can pass completion options to enable/disable.

    zstyle -a ':zoppo:plugin:completion' options \
      'complete-in-word' 'always-to-end' 'path-dirs' 'auto-menu' 'auto-list' 'auto-param-slash' \
      'no-menu-complete' 'no-flow-control'

[1]: https://github.com/zsh-users/zsh-completions
