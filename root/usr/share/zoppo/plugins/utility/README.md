Utility
=======
This plugin defines and loads various utilities, configuring them properly.

Load Zsh utilities
------------------
You can enabled/disable loading of various useful Zsh utilities of the caliber
of *ztodo* and *zmv*.

Enabled by default.

    zstyle ':zoppo:plugin:utility:zsh' enable 'no'

Load GNU utilities
------------------
If you have GNU utilities installed with a prefix, you can have them loaded and
usable like they were installed without a prefix.

The default prefix is `g`, the default binaries are a lot (check the source).

    zstyle ':zoppo:plugin:utility:gnu' enable 'yes'
