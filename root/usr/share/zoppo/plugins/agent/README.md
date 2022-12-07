Agent
=====
This plugin provides for an easier use of [ssh-agent][1] and [gpg-agent][2].

Enable SSH Agent
----------------
You can enable or disable ssh-agent support by either setting `yes` or `no`.

The default is `yes`.

    zstyle ':zoppo:plugin:agent:ssh' enable 'yes'

Enable SSH Agent Forwarding
---------------------------
The default is `no`.

    zstyle ':zoppo:plugin:agent:ssh' forwarding 'yes'

Enable SSH Agent Identities
---------------------------
You can enable multiple identities.

    zstyle ':zoppo:plugin:agent:ssh' identities 'id_rsa' 'id_rsa2' 'id_github'

Enable GPG Agent
----------------
You can enable or disable gpg-agent by either setting `yes` or `no`.

The default is `no`.

    zstyle ':zoppo:plugin:agent:gpg' enable 'yes'

[1]: http://www.openbsd.org/cgi-bin/man.cgi?query=ssh-agent&sektion=1
[2]: http://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
