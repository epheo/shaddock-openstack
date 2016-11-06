FROM archlinux:latest
MAINTAINER epheo <shaddock@epheo.eu>

RUN pacman -Syu --noconfirm python2-virtualenv git libffi gcc libpqxx mariadb-clients

ADD openstack-venv-fix.sh ./

ENTRYPOINT ["/bin/bash","openstack-venv-fix.sh"]
