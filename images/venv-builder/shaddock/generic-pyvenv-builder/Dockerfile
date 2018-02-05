FROM shaddock/archlinux:latest
MAINTAINER epheo <shaddock@epheo.eu>

RUN pacman -Sy --noconfirm \
                  python2-virtualenv \
                  git \
                  libffi \
                  gcc \
                  libpqxx \
                  mariadb-clients \
                  mysql-python 

RUN mkdir -p /opt/openstack/venv/

RUN ln -s /usr/lib/libffi-*/include/ /usr/include/libffi

ADD pull_from_remote.sh /usr/bin/
ADD update_symlinks.sh /usr/bin/
ADD builder.sh /usr/bin/
ADD post-conf.sh /usr/bin/

CMD ["builder.sh"]
