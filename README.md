# OSTree-native container distribution of configs across personal desktop workstation

This repository is meant to version my workstations configuration for their OSTree-based Fedora Kinoite installations and to deliver upgrades to those workstation (both packages and host-configuration) by exploiting the OSTree native container feature and a CI based on GitHub actions.

The BaseOS image is built from the original workstation-ostree-config [pagure repository](https://ostreedev.github.io/ostree/) with no modifications and until issues at [^1][^2] are ready.

On top of the BaseOS image, I'm using layering to deliver non-sensitive content via the OCI images stored in quay.io. My systems are then tracking a tag in the quay.io repository, upgrading automatically to my latest commit in this repository.


Further considerations at: https://www.aleskandro.com/posts/rpm-ostree-container-native-fedora-silverblue-kinoite-dual-boot/

[^1]: https://discussion.fedoraproject.org/t/feature-for-custom-rpm-ostree-container-native-builds/44480
[^2]: https://github.com/fedora-silverblue/issue-tracker/issues/359

