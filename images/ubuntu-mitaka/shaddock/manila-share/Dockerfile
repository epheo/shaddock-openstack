FROM shaddock/seed:ubuntu-mitaka
MAINTAINER Thibaut Lapierre <root@epheo.eu>

#Install Manila share
RUN apt-get -y update
RUN pip uninstall -y pbr
RUN apt-get install -y --force-yes manila-share python-pymysql \
                                   lvm2 nfs-kernel-server

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/manila"]

ADD manila-share-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/manila-share-start
RUN chmod +x /usr/local/bin/configparse.py

CMD ["manila-share-start"]
