FROM shaddock/seed:latest
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm apache \
                           mod_wsgi2 \
                           python2-memcached \
                           memcached

ADD supervisord.conf /etc/supervisord.conf

VOLUME ["/var/log/horizon"]

ADD horizon-start /usr/local/bin/
RUN chmod +x /usr/local/bin/horizon-start

EXPOSE 80
EXPOSE 11211

CMD ["horizon-start"]
