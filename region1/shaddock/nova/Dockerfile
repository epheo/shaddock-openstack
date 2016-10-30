FROM shaddock/seed:latest
MAINTAINER epheo <github@epheo.eu>

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/nova"]

ADD nova-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/nova-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 9774
EXPOSE 8775

CMD ["nova-start"]
