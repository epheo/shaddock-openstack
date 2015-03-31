FROM panama/base:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

#install nova
RUN apt-get update
RUN apt-get install -y nova-api nova-cert nova-conductor nova-consoleauth \
  nova-novncproxy nova-scheduler python-novaclient

RUN apt-get install -y neutron-server neutron-plugin-ml2 python-neutronclient

#Setup supervisord
ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/nova"]

ADD nova-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/nova-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 9774
EXPOSE 8775
EXPOSE 9696

CMD ["nova-start"]
