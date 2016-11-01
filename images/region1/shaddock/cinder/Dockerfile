FROM shaddock/seed:latest
MAINTAINER epheo <github@epheo.eu>

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/cinder"]

ADD cinder-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/cinder-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 8776

CMD ["cinder-start"]
