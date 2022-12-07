Editor
======
The editor plugin sets various keybindings and other editor goodies.

Dumb Terminals
--------------
There's some dumb terminal support, not all terminals are smart
enough to provide correct terminfos, so zoppo tries to fix that
adding various known key bindings.

You can enable/disable this feature, as usual.

    zstyle ':zoppo:plugin:editor' dumb 'no'

Editor Mode
-----------
You can either set `emacs` or `vi` mode.

The default is `emacs`.

    zstyle ':zoppo:plugin:editor' mode 'emacs'

Word Characters
---------------
You can set what characters are saw as part of the word.

The default is `*?_-.[]~&;!#$%^(){}<>`.

    zstyle ':zoppo:plugin:editor' wordchars '*?_-.[]~&;!#$%^(){}<>'

Dot Expansion
-------------
You can enable/disable a special dot expansion function that autocompletes with
the realpath when you insert `..`.

It's enabled by default.

    zstyle ':zoppo:plugin:editor' dot-expansion 'no'

Beep
----
You can enable beeps on error if you want.

The default is disabled.

    zstyle ':zoppo:plugin:editor' beep 'yes'
