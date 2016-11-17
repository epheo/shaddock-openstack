FROM shaddock/archlinux:latest
MAINTAINER epheo <shaddock@epheo.eu>

RUN pacman -Syu --noconfirm python2-virtualenv git libffi gcc libpqxx
RUN mkdir -p /opt/openstack/venv/

ADD builder.sh ./
ADD create_symlinks.sh ./
ADD openstack-venv-fix.sh ./


CMD ["builder.sh","/opt/openstack/venv"]
