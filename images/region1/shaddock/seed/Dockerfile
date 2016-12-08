FROM shaddock/archlinux:latest
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Syu --noconfirm supervisor \
                            mariadb-clients \
                            mysql-python \
                            python2-memcached \
                            libidn
ADD generate-osrc.sh /usr/bin/
ONBUILD ADD run.sh /usr/bin/
ONBUILD ADD configparse.py /opt/
ONBUILD ADD supervisord.conf /etc/

CMD ["run.sh"]
