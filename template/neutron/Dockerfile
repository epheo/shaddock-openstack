FROM panama/base:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

# Install Neutron
RUN apt-get install -y neutron python-neutron
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/log/neutron"]

RUN \
    (crontab -l -u neutron 2>&1 | grep -q token_flush) || \
    echo '@hourly /usr/bin/neutron-manage token_flush >/var/log/neutron/neutron-tokenflush.log 2>&1' \
    >> /var/spool/cron/crontabs/neutron

ADD neutron-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/neutron-start

EXPOSE 35357
EXPOSE 5000

CMD ["neutron-start"]
