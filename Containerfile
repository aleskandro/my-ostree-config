FROM quay.io/aleskandrox/fedora-kinoite:rawhide

ENTRYPOINT ["/bin/bash"]

RUN set -x; arch=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'); cat /etc/os-release \
    && rpm-ostree install \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && rpm-ostree cleanup -m && ostree container commit

RUN set -x; rpm-ostree override remove vim-data vim-minimal \
 && rpm-ostree cleanup -m && ostree container commit

RUN set -x; rpm-ostree update; rpm-ostree install \
        curl gawk git git-lfs htop iftop iputils iproute fping socat mtr net-tools bind-utils iperf iperf3 tcpdump procps \
        jq ncdu nethogs nmap nmap-ncat openssl openvpn rsync conntrack-tools iputils ethtool strace \
        qemu-kvm bridge-utils libvirt libvirt-daemon gnupg2 screen subversion skopeo sudo tftp unzip util-linux-user \
        qemu-user-static wget python3-pip zsh ignition vim neovim mozilla-openh264 \
 && rpm-ostree cleanup -m && ostree container commit

RUN set -x; arch=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'); \
    download_latest () { \
        url=$(curl https://api.github.com/repos/$1/$2/releases/latest | jq -r \
            '.assets | .[] | select(.name|test("'$3'")) | .browser_download_url'); \
        wget -qO $4 $url; \
    }; \
    download_latest docker compose ".*linux.*$(uname -m)$" /usr/bin/docker-compose \
 && download_latest mikefarah yq "linux.*$arch" /usr/bin/yq \
 && download_latest wagoodman dive ".*linux.*$arch.*tar.gz" /tmp/dive.tar.gz \
 && tar -C /usr/bin/ -xvf /tmp/dive.tar.gz dive \
 && rm -f /tmp/dive.tar.gz \
 && chmod +x /usr/bin/{docker-compose,yq,dive} \
 && rpm-ostree cleanup -m && ostree container commit

COPY root/ /

RUN set -x; printf '\
[ -s "/usr/share/zoppo/zoppo.zsh" ] && source "/usr/share/zoppo/zoppo.zsh"\n\
[ -e ~/.zopporc ] || { echo "Configuring zsh."; ln -s /usr/share/zoppo/zopporc ~/.zopporc; exec /usr/bin/zsh }\n\
setopt prompt_subst' >> /etc/zshrc \
 && echo 'PATH=~/bin:~/.bin:~/.opt/bin:$PATH' >> /etc/zshenv \
 && chsh -s /bin/zsh root  \
 && ostree container commit

RUN set -x; update-crypto-policies --set legacy --no-reload \
 && rpm-ostree cleanup -m && ostree container commit

RUN set -x; sed -i 's/AutomaticUpdatePolicy=.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf \
 && systemctl enable rpm-ostreed-automatic.timer initramfs-rebuild.service \
 && rpm-ostree cleanup -m && ostree container commit

RUN set -x; sed -i 's/VARIANT_ID^/VARIANT_ID/' /etc/profile.d/toolbox.sh

