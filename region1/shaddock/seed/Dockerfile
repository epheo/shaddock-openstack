FROM archlinux:latest
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm supervisor

ADD cloud-config /usr/local/bin/
RUN chmod +x /usr/local/bin/cloud-config

CMD ["cloud-config"]
