FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Syu --noconfirm iptables

VOLUME  ["/var/log/nova"]

EXPOSE 9774
EXPOSE 8775
