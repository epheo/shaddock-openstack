FROM shaddock/seed:latest
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm apache \
                           mod_wsgi2

ADD wsgi-keystone.conf /etc/apache2/sites-enabled/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD keystone-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/keystone-start
RUN chmod +x /usr/local/bin/configparse.py

VOLUME ["/var/log/keystone"]

EXPOSE 35357
EXPOSE 5000

CMD ["keystone-start"]
