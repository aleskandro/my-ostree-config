FROM quay.io/aleskandrox/fedora-kinoite:rawhide

ENTRYPOINT ["/bin/bash"]

RUN set -x; arch=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'); cat /etc/os-release \
    && rpm-ostree install \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && rpm-ostree cleanup -m && ostree container commit

RUN set -x; rpm-ostree update; rpm-ostree install \
        curl gawk git git-lfs htop iftop iputils iproute fping socat mtr net-tools bind-utils iperf iperf3 tcpdump procps \
        jq ncdu nethogs nmap nmap-ncat openssl openvpn rsync conntrack-tools iputils ethtool strace mtr \
        qemu-kvm bridge-utils libvirt libvirt-daemon gnupg2 screen subversion skopeo sudo tftp unzip util-linux-user \
        qemu-user-static wget python3-pip zsh ignition vim neovim mozilla-openh264 \
    && rpm-ostree cleanup -m && ostree container commit

COPY root/ /

RUN set -x; \
    HOME=/tmp RUNZSH=no CHSH=no ZSH=/usr/lib/ohmyzsh \
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && wget -qO /usr/lib/ohmyzsh/custom/kube-ps1.plugin.zsh \
        https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/kube-ps1/kube-ps1.plugin.zsh \
    && mv /usr/share/zsh/*.zsh /usr/lib/ohmyzsh/custom/ \
    && git clone https://github.com/zsh-users/zsh-history-substring-search \
     /usr/lib/ohmyzsh/custom/plugins/zsh-history-subscring-search \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
     /usr/lib/ohmyzsh/custom/plugins/zsh-syntax-highlighting \
    && chsh -s /bin/zsh root \
    && echo 'PATH=~/bin:~/.bin:~/.opt/bin:$PATH' >> /etc/zshenv \
    && sed -i 's|^SHELL=.*|SHELL=/usr/bin/zsh|' /etc/default/useradd \
    # ${VARIANT_ID^} is not posix compliant and is not parsed correctly by zsh \
    && sed -i 's/VARIANT_ID^/VARIANT_ID/' /etc/profile.d/toolbox.sh \
    && rpm-ostree cleanup -m && ostree container commit

RUN set -x; update-crypto-policies --set legacy --no-reload \
 && rpm-ostree cleanup -m && ostree container commit

RUN set -x; sed -i 's/AutomaticUpdatePolicy=.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf \
 && systemctl enable rpm-ostreed-automatic.timer initramfs-rebuild.service \
 && rpm-ostree cleanup -m && ostree container commit
