# OSTree-native container distribution of configs across personal desktop workstations

This repository is meant to version my CoreOS-based servers' and workstations' configurations.

I make use of OSTree-native containers, building on top of Fedora CoreOS and Fedora Kinoite/Silverblue, respectively for servers and workstations.

- os_desktop.Containerfile hosts the configuration for my Fedora Kinoite workstations.
- os_microshift.Containerfile produces an embedded MicroShift cluster for single-node Kubernetes workloads on Fedora CoreOS.


## Installation

Given a Fedora CoreOS fresh installation, you can deploy either the Microshift or the Kinoite/Silverblue configuration by running:

```bash
rpm-ostree rebase ostree-unverified-registry:<container-image>
```

Ignition files for Fedora CoreOs can be provided at installation time and later consumed after the rebase.

### Kinoite/Silverblue configuration

For Fedora Kinoite/Silverblue, the only requirement for the ignition is to disable zincati, and setup the users and hostnames as desired:

Example Butane configuration:

```yaml
variant: fcos
version: 1.3.0
systemd:
  units:
    - name: zincati.service
      enabled: false
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - ssh-ed25519 XXXX ...
      password_hash: <Generate with podman run -ti --rm quay.io/coreos/mkpasswd>
    - name: aleskandro
      ssh_authorized_keys:
        - ssh-ed25519 yyyy XXXX
      password_hash: <Generate with podman run -ti --rm quay.io/coreos/mkpasswd>
      groups: [ ... ]
storage:
  files:
    - path: /etc/hostname
      mode: 0644
      user:
        id: 0
      group:
        id: 0
      contents:
        inline: >-
          <my-hostname>
```


### Microshift configuration

For the Microshift configuration, you can provide an Ignition file that provisions the configuration for Microshift itself, including the Kubernetes manifests you want to deploy on the single-node cluster. See the Microshift documentation for more details about the configuration files to provide.

- A dated blog about a more complex scenario involving dual-boot: https://www.aleskandro.com/posts/rpm-ostree-container-native-fedora-silverblue-kinoite-dual-boot/

