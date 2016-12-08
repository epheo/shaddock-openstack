FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm iptables git net-tools

RUN git clone https://github.com/kanaka/noVNC /usr/share/novnc &&\
    ln -s /noVNC/utils/launch.sh /usr/share/novnc &&\
    ln -s /usr/share/novnc/utils/launch.sh /usr/bin/novnc

VOLUME  ["/var/log/nova"]

EXPOSE 9774
EXPOSE 8775
