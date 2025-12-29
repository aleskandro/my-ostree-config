ARG BASE_REPO=quay.io/centos/centos
ARG BASE_TAG=stream10
FROM ${BASE_REPO}:${BASE_TAG}

ARG PACKAGES_INSTALL_ADDITIONAL=""

COPY *.list /tmp/
RUN set -x; arch=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'); cat /etc/os-release \
    && dnf install -y \
        epel-release \
        python3-pip \
        python3-devel \
    && dnf config-manager --add-repo https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo \
    && dnf install -y $(</tmp/packages.list) ${PACKAGES_INSTALL_ADDITIONAL} && dnf install -y nvidia-container-toolkit \
    && dnf clean all && rm -rf /tmp/*.list

COPY overlay.d/01-common/ /

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
    && sed -i 's|^SHELL=.*|SHELL=/usr/bin/zsh|' /etc/default/useradd

RUN zsh -xc 'source /usr/lib/ohmyzsh/custom/30zinitrc.zsh; source /usr/bin/install-vendor-binaries.zsh' \
    /usr/local/bin/helm plugin install https://github.com/databus23/helm-diff

RUN dnf install -y python3 python3-pip python3-devel && dnf clean all

# Core Python tools for debugging, profiling, and benchmarking
RUN pip install --no-cache-dir -U \
    vllm torch torchvision torchaudio \
    torchinfo rich loguru psutil gpustat pynvml \
    prometheus_client tensorboard \
    aiohttp requests tqdm \
    opentelemetry-api opentelemetry-sdk opentelemetry-exporter-otlp \
    # perfetto-client \
    && pip cache purge


ENV VLLM_TRACE_PATH=/tmp/vllm_trace.json \
    CUDA_LAUNCH_BLOCKING=0 \
    NCCL_DEBUG=INFO \
    TORCH_DISTRIBUTED_DEBUG=DETAIL \
    OMP_NUM_THREADS=1 \
    PYTHONUNBUFFERED=1 \
    PATH=/root/.local/bin:/root/bin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin \
    HOME=/root

LABEL maintainer="aleskandro@redhat.com" \
      description="Fedora-based vLLM benchmarking and debugging environment with GPU/system monitoring tools."

WORKDIR /workspace
ENTRYPOINT ["/bin/bash"]
