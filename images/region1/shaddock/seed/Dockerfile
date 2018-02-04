FROM shaddock/archlinux:latest
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Syu --noconfirm supervisor \
                            mariadb-clients \
                            mysql-python \
                            python2-memcached \
                            libidn \
                            python2-pip

RUN pip2 install crudini
RUN sed -i '/draig\ Brady/c\\#\ Copyright\ Padraig\ Brady\ \<PadraigBrady\.com\>' \
    /usr/bin/crudini
ADD generate-osrc.sh /usr/bin/
ONBUILD ADD run.sh /usr/bin/

CMD ["run.sh"]
