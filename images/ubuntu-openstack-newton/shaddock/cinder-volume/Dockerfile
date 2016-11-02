FROM shaddock/seed:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

#install cinder
RUN apt-get -y update
RUN pip uninstall -y pbr
RUN apt-get install -y --force-yes lvm2 tgt cinder-volume

RUN echo "cinder ALL = (root) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers

ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/cinder"]

ADD cinder-volume-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/cinder-volume-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 8776

CMD ["cinder-volume-start"]
