FROM shaddock/seed:ubuntu-mitaka
MAINTAINER Thibaut Lapierre <root@epheo.eu>

#Install manila
RUN apt-get -y update
RUN pip uninstall -y pbr
RUN apt-get install -y --force-yes manila-api manila-scheduler \
                                  python-pymysql python-manilaclient

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/manila"]

ADD manila-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/manila-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 8786

CMD ["manila-start"]
