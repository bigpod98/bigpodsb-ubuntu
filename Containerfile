ARG FEDORA_MAJOR_VERSION=37

FROM ghcr.io/ublue-os/base:${FEDORA_MAJOR_VERSION}

COPY etc /etc
COPY usr /usr

COPY --from=ghcr.io/ublue-os/udev-rules etc/udev/rules.d/* /etc/udev/rules.d

RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/gnome-vrr/repo/fedora-$(rpm -E %fedora)/kylegospo-gnome-vrr-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-gnome-vrr.repo
RUN wget https://copr.fedorainfracloud.org/coprs/sunwire/input-remapper/repo/fedora-37/sunwire-input-remapper-fedora-37.repo -O /etc/yum.repos.d/sunwire-input-remapper-fedora-37.repo
RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/webapp-manager/repo/fedora-37/kylegospo-webapp-manager-fedora-37.repo -O /etc/yum.repos.d/kylegospo-webapp-manager-fedora-37.repo
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:kylegospo:gnome-vrr mutter gnome-control-center gnome-control-center-filesystem
RUN rpm-ostree override remove evince-djvu evince-libs evince-previewer evince-thumbnailer gnome-tour \
    gnome-user-docs nvidia-gpu-firmware && \
    rpm-ostree override remove  vim-minimal virtualbox-guest-additions yelp yelp-libs yelp-xsl && \
    rpm-ostree install https://packages.microsoft.com/yumrepos/vscode/Packages/c/code-1.75.1-1675893486.el7.x86_64.rpm && \
    rpm-ostree install gnome-shell-extension-appindicator gnome-shell-extension-dash-to-dock \
    gnome-shell-extension-gsconnect nautilus-gsconnect just libgda libgda-sqlite libratbag-ratbagd openssl podman-docker \
    python3-input-remapper tailscale virt-manager alacritty htop wireguard-tools webapp-manager yaru-theme fish  && \
    rm -f /var/lib/unbound/root.key && \
    rm -f /var/lib/freeipmi/ipckey && \
    systemctl unmask dconf-update.service && \
    systemctl enable dconf-update.service && \
    systemctl enable rpm-ostree-countme.service && \
    systemctl enable tailscaled.service && \
    fc-cache -f /usr/share/fonts/ubuntu && \
    rm -f /etc/yum.repos.d/lyessaadi-blackbox.repo && \
    rm -f /etc/yum.repos.d/_copr_kylegospo-gnome-vrr.repo && \
    rm -f /etc/yum.repos.d/tailscale.repo && \
    rm -f /etc/yum.repos.d/sunwire-input-remapper-fedora-37.repo && \
    rm -f /etc/yum.repos.d/kylegospo-webapp-manager-fedora-37.repo && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    ostree container commit

COPY --from=cgr.dev/chainguard/kubectl:latest /usr/bin/kubectl /usr/bin/kubectl
COPY --from=cgr.dev/chainguard/cosign:latest /usr/bin/cosign /usr/bin/cosign
