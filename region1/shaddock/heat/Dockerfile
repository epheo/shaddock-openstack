FROM shaddock/seed:latest
MAINTAINER epheo <github@epheo.eu>

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/heat"]

ADD heat-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/heat-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 8000
EXPOSE 8004
CMD ["heat-start"]
