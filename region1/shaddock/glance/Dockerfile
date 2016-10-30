FROM shaddock/seed:latest
MAINTAINER epheo <github@epheo.eu>

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/glance", "/var/lib/glance/images"]

ADD glance-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/glance-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 9292
CMD ["glance-start"]
