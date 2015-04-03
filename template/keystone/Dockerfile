FROM panama/base:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

# Install Keystone
RUN apt-get update
#RUN apt-get install -y keystone python-keystone

##
RUN apt-get install -y git python-dev libffi-dev libssl-dev
RUN pip install pbr
RUN git clone https://github.com/openstack/keystone /opt/keystone/
RUN cd /opt/keystone && python setup.py install

##

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
