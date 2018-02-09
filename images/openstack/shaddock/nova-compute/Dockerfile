FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm libvirt-python \
                           sysfsutils \
                           libvirt \
                           qemu \
                           python2

VOLUME  ["/var/log/nova"]

EXPOSE 8775
