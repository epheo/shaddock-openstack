FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm apache \
                           mod_wsgi2 \
                           python2-memcached

RUN mkdir -p /run/httpd/
ADD wsgi-horizon.conf /etc/httpd/conf/wsgi-horizon.conf

RUN useradd http
RUN useradd daemon

VOLUME ["/var/log/horizon"]

EXPOSE 80
