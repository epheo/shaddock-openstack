FROM shaddock/seed:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

RUN apt-get update &&\
    apt-get install -y neutron-api neutron-cert neutron-conductor neutron-consoleauth \
                       neutron-novncproxy neutron-scheduler python-neutronclient

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/neutron"]

ADD neutron-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/neutron-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 9774
EXPOSE 8775
EXPOSE 9696

CMD ["neutron-start"]
