FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm libvirt-python \
                            sysfsutils \
                            libvirt \
                            qemu \
                            gcc \
                            python2-pip

RUN pip2 install oslo_concurrency

VOLUME  ["/var/log/nova"]

EXPOSE 8775
