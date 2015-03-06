FROM panama/base:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>
# http://docs.openstack.org/icehouse/install-guide/install/yum/content/keystone-install.html

# Install Keystone
RUN apt-get install -y keystone python-keystone
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/log/keystone"]

RUN \
    (crontab -l -u keystone 2>&1 | grep -q token_flush) || \
    echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' \
    >> /var/spool/cron/crontabs/keystone

RUN pip install future
ADD keystone-start /usr/local/bin/
ADD configparser.py /
RUN chmod +x /usr/local/bin/keystone-start

EXPOSE 35357
EXPOSE 5000

CMD ["keystone-start"]
