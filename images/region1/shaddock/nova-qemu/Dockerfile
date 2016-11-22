FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Syu --noconfirm libvirt-python \
                            sysfsutils \
                            libvirt \
                            qemu

VOLUME  ["/var/log/nova"]

EXPOSE 8775
