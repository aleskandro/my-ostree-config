Archive
=======
This plugin provides wrappers for various archive tools.

It's extensible and pluggable.

Functions
---------
- `extract` extracts the contents of one or more archives.
- `ls-archive` lists the contents of one archive.

Supported Formats
-----------------
- *.tar.gz*, *.tgz* require `tar`.
- *.tar.bz2*, *.tbz* require `tar`.
- *.tar.xz*, *.txz* require `tar` with *xz* support.
- *.tar.zma*, *.tlz* require `tar` with *lzma* support.
- *.tar* requires `tar`.
- *.gz* requires `gunzip`.
- *.bz2* requires `bunzip2`.
- *.xz* requires `unxz`.
- *.lzma* requires `unlzma`.
- *.Z* requires `uncompress`.
- *.zip* requires `unzip`.
- *.rar* requires `unrar`.
- *.7z* requires `7za`.
- *.deb* requires `ar`, `tar`.

Disable extensions
------------------
You can disable certain extensions for specific functionalities or globally.

    zstyle ':zoppo:plugin:archive' disable 'deb' 'tar.gz'
    zstyle ':zoppo:plugin:archive:extract' disable 'tar.xz'

