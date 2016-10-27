FROM archlinux:latest
MAINTAINER epheo <shaddock@epheo.eu>

RUN pacman -Syu --noconfirm python2-virtualenv git libffi gcc libpqxx

RUN mkdir /opt/openstack/

ADD builder.sh ./

ENTRYPOINT ["/bin/bash","builder.sh","/opt/openstack"]
