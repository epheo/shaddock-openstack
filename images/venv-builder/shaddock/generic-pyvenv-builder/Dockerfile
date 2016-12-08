FROM shaddock/archlinux:latest
MAINTAINER epheo <shaddock@epheo.eu>

RUN pacman -Sy --noconfirm python2-virtualenv git libffi gcc libpqxx
RUN mkdir -p /opt/openstack/venv/

RUN ln -s /usr/lib/libffi-*/include/ /usr/include/libffi

ADD builder.sh /usr/bin/
ADD create_symlinks.sh /usr/bin/
ADD openstack-venv-fix.sh /usr/bin/

CMD ["builder.sh","/opt/openstack/venv"]
