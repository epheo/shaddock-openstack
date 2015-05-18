FROM shaddock/seed:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

RUN apt-get update \
    apt-get install -y keystone


ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/log/keystone"]

RUN \
    (crontab -l -u keystone 2>&1 | grep -q token_flush) || \
    echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' \
    >> /var/spool/cron/crontabs/keystone

ADD keystone-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/keystone-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 35357
EXPOSE 5000

CMD ["keystone-start"]