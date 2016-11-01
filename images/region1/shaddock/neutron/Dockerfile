FROM shaddock/seed:latest
MAINTAINER epheo <github@epheo.eu>

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/neutron"]

ADD neutron-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/neutron-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 9696

CMD ["neutron-start"]
