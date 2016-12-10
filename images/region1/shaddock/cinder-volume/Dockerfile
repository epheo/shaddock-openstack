FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm lvm2 sudo git
RUN pacman -Sy --noconfirm --needed base-devel

RUN echo "cinder ALL = (root) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers
RUN echo "nobody ALL = (root) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers

RUN git clone https://aur.archlinux.org/perl-config-general.git /tmp/perl-config-general
RUN chgrp nobody /tmp/perl-config-general && chmod g+ws /tmp/perl-config-general
RUN cd /tmp/perl-config-general && sudo -u nobody makepkg -si --noconfirm
RUN git clone https://aur.archlinux.org/tgt.git /tmp/tgt
RUN chgrp nobody /tmp/tgt && chmod g+ws /tmp/tgt
RUN cd /tmp/tgt && sudo -u nobody makepkg -si --noconfirm

VOLUME  ["/var/log/cinder"]

EXPOSE 8776
