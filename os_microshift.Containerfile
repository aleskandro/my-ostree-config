ARG BASE_REPO=quay.io/fedora/fedora-coreos
ARG BASE_TAG=next
FROM quay.io/fedora/fedora-minimal:latest as artifacts

COPY overlay.d/00-temp/ /

RUN microdnf install --setopt=install_weak_deps=False \
        -y rpmbuild && chmod +x /usr/bin/fakerpm.sh \
    && mkdir -p /srv/fakerpms/ && pushd /srv/fakerpms/ \
    && /usr/bin/fakerpm.sh openvswitch3.3 \
    # See https://github.com/openshift/microshift/pull/967
    && /usr/bin/fakerpm.sh openshift-clients
    # Prefer to use the clients from the OKD's GitHub release page

FROM ${BASE_REPO}:${BASE_TAG}

ENTRYPOINT ["/bin/bash"]

RUN set -x; arch=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'); cat /etc/os-release \
    && rpm-ostree install \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && ostree container commit

COPY *.list /tmp/
RUN set -x; cat /etc/os-release; rpm-ostree --version; ostree --version; \
    rpm-ostree install $(</tmp/packages.list) \
    && ln -sf /usr/bin/netcat /usr/bin/nc \
    && rm -rf /tmp/*.list \
    && rm -rf /var/lib/{unbound,gssproxy,nfs} \
    && ostree container commit

COPY overlay.d/01-common/ /
COPY overlay.d/05-systemd/ /
COPY overlay.d/10-fcos/ /
COPY overlay.d/15-microshift/ /
COPY --from=artifacts /srv/fakerpms/ /tmp/rpms/

RUN set -x; PACKAGES_INSTALL="NetworkManager-ovs cri-o cri-tools /tmp/rpms/*.rpm"; \
    rpm-ostree install $PACKAGES_INSTALL \
    && rpm-ostree install microshift \
    && ls -l /usr/sbin/ovs-vswitchd \
    # && ln -s /usr/sbin/ovs-vswitchd.dpdk /usr/sbin/ovs-vswitchd \
    && rm -rf /tmp/rpms \
    # ex rebuild will consume the /etc/rpm-ostree/origin.d overrides
    && rpm-ostree ex rebuild \
    && rpm-ostree cleanup -m \
    && rm -rf /var/lib/{unbound,gssproxy,nfs} \
    && ostree container commit

RUN set -x; sed -i \
      's/#AutomaticUpdatePolicy=.*/AutomaticUpdatePolicy=stage/' \
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

# This dir should be created by the microshift package that sets it in the plugins dir for CNI or by crio.
# Maybe crio created this directory earlier and the microshift devs wanted to maintain it set, but it does not happen anymore.
# Since the dir doesn't exist and /usr is read-only in FCOS, crio fails to start.
# https://github.com/openshift/microshift/blob/06e9ae203c157f33d6570153152e2fb360bf8eae/packaging/crio.conf.d/10-microshift_arm64.conf#L18-L20
RUN mkdir -p /usr/libexec/cni

LABEL quay.expires-after=30d
