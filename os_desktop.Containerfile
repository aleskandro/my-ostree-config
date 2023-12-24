ARG BASE_REPO=quay.io/aleskandrox/fedora
ARG BASE_TAG=kinoite-rawhide
FROM ${BASE_REPO}:${BASE_TAG}

ARG TOOLBOX_IMAGE=quay.io/aleskandrox/fedora:toolbox
ENTRYPOINT ["/bin/bash"]

RUN set -x; arch=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'); cat /etc/os-release \
    && rpm-ostree install \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && ostree container commit

COPY *.list /tmp
RUN set -x; cat /etc/os-release; rpm-ostree --version; ostree --version; \
    rpm-ostree install $(</tmp/packages.list) $(</tmp/packages.virt.list) $(</tmp/packages.desktop.list) \
    && ln -sf /usr/bin/ld.bfd /usr/bin/ld \
    && ln -sf /usr/bin/netcat /usr/bin/nc \
    && rm -rf /var/lib/{unbound,gssproxy,nfs} \
    && ostree container commit

# FIXME: Remove the replacement for releasever once fedora-cisco-openh264 provides builds for fedora 40.
RUN set -x; sed -i "s/\$releasever/39/g" /etc/yum.repos.d/fedora-cisco-openh264.repo; \
    rpm-ostree override remove mesa-va-drivers libavcodec-free \
      libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free \
      --install ffmpeg --install mesa-va-drivers-freeworld

RUN set -x; if rpm -qa | grep -q gnome-desktop; then \
    PACKAGES_INSTALL="gnome-tweaks tilix gnome-extensions-app gedit evince evolution"; \
    rpm-ostree install $PACKAGES_INSTALL && ostree container commit; fi

RUN set -x; if rpm -qa | grep -q plasma-desktop; then \
      PACKAGES_INSTALL="kdepim okular gwenview"; \
      rpm-ostree install $PACKAGES_INSTALL && ostree container commit; fi

# The repositories for docker-ce are currently pinned to Fedora 39.
RUN set -x; \
    source /etc/os-release; \
    curl -L https://download.docker.com/linux/fedora/docker-ce.repo | releasever=39 envsubst '$releasever' \
        | tee /etc/yum.repos.d/docker-ce.repo \
    && rpm-ostree install docker-ce docker-ce-cli && ostree container commit

COPY overlay.d/01-common/ /
COPY overlay.d/05-systemd/ /
COPY overlay.d/10-desktop/ /

RUN set -x; sed -i \
      's/AutomaticUpdatePolicy=.*/AutomaticUpdatePolicy=stage/' \
      /etc/rpm-ostreed.conf \
    && systemctl preset-all \
    && ostree container commit

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
    # ${VARIANT_ID^} is not posix compliant and is not parsed correctly by zsh \
    && sed -i 's/VARIANT_ID^/VARIANT_ID/' /etc/profile.d/toolbox.sh \
    && ostree container commit

RUN set -x; update-crypto-policies --set legacy --no-reload \
    && echo "image = \"${TOOLBOX_IMAGE}\"" >> /etc/containers/toolbox.conf \
    && ostree container commit
