Syntax Highlighting
===================
Integrates [zsh-syntax-highlighting][1] into *zoppo*.

Highlighters
------------
Syntax highlighting is accomplished by pluggable [highlighters][2]. This module
enables the *main*, *brackets*, and *cursor* highlighters by default.

To enable all highlighters, use the following configuration:

    zstyle ':zoppo:plugin:syntax-highlight' highlighters 'main' 'brackets' 'pattern' 'cursor' 'root'

[1]: https://github.com/zsh-users/zsh-syntax-highlighting
[2]: https://github.com/zsh-users/zsh-syntax-highlighting/tree/master/highlighters
