FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm apache mod_wsgi2

ADD wsgi-keystone.conf /etc/httpd/

RUN mkdir -p /etc/httpd/logs/
RUN mkdir -p /run/httpd/

VOLUME ["/var/log/keystone"]

EXPOSE 35357
EXPOSE 5000
