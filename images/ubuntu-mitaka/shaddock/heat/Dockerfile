FROM shaddock/seed:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

#Install heat
RUN apt-get -y update
RUN pip uninstall -y pbr
RUN apt-get install -y --force-yes heat-api heat-api-cfn heat-engine

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/heat"]

ADD heat-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/heat-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 8000
EXPOSE 8004
CMD ["heat-start"]
