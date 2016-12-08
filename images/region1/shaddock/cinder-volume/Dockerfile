FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm lvm2 sudo
ADD supervisord.conf /etc/supervisord.conf

RUN echo "cinder ALL = (root) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers

VOLUME  ["/var/log/cinder"]

EXPOSE 8776
