FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm libvirt-python \
                            sysfsutils \
                            libvirt \
                            qemu \
                            python2


RUN ln -s \
 /opt/openstack/services/horizon/lib/python2.7/site-packages/oslo_concurrency/ \
 /usr/lib/python2.7/site-packages/

VOLUME  ["/var/log/nova"]

EXPOSE 8775
