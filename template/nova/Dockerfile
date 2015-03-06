FROM panama/base:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>
# http://docs.openstack.org/icehouse/install-guide/install/yum/content/nova-controller.html

#install nova
RUN apt-get update
RUN apt-get install -y install nova-api nova-cert nova-conductor nova-consoleauth \
  nova-novncproxy nova-scheduler python-novaclient

#Setup supervisord
ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/nova"]

ADD nova-start /usr/local/bin/
ADD configparser.py /
RUN chmod +x /usr/local/bin/nova-start

EXPOSE 9774
EXPOSE 8775

CMD ["nova-start"]
