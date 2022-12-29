ARG BASE_REPO=registry.fedoraproject.org/fedora-toolbox
ARG BASE_TAG=testing
FROM ${BASE_REPO}:${BASE_TAG}

ARG PACKAGES_INSTALL="bridge-utils conntrack-tools curl fping iftop iputils iproute mtr nethogs socat \
    net-tools bind-utils iperf iperf3 iputils mtr ethtool tftp wget ipmitool \
    gnupg2 openssl openvpn rsync tcpdump nmap nmap-ncat \
    gawk htop ncdu procps strace subversion git git-lfs \
    sudo screen unzip util-linux-user ignition \
    zsh python3-pip skopeo jq vim neovim wine"

ARG PACKAGES_INSTALL_ADDITIONAL=""

RUN set -x; arch=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'); cat /etc/os-release \
    && dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && dnf install -y ${PACKAGES_INSTALL} ${PACKAGES_INSTALL_ADDITIONAL} \
    && dnf clean all

COPY root/ /

RUN HOME=/tmp RUNZSH=no CHSH=no ZSH=/usr/lib/ohmyzsh \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && set -x \
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
