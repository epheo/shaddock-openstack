FROM shaddock/seed:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

#Install Nova from Master branch
RUN git clone https://github.com/openstack/nova /opt/nova/
RUN cd /opt/nova && python setup.py install

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
