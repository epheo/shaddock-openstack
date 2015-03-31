FROM panama/base:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

# Install Cinder
RUN apt-get install -y cinder python-cinder
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/log/cinder"]

RUN \
    (crontab -l -u cinder 2>&1 | grep -q token_flush) || \
    echo '@hourly /usr/bin/cinder-manage token_flush >/var/log/cinder/cinder-tokenflush.log 2>&1' \
    >> /var/spool/cron/crontabs/cinder

ADD cinder-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/cinder-start

EXPOSE 35357
EXPOSE 5000

CMD ["cinder-start"]
