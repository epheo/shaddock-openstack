FROM shaddock/archlinux:latest
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Syu --noconfirm supervisor \
                            mariadb-clients \
                            mysql-python \
                            libidn
ONBUILD ADD run.sh /usr/bin/
ONBUILD ADD configparse.py /opt/
ONBUILD ADD supervisord.conf /etc/

CMD ["run.sh"]
