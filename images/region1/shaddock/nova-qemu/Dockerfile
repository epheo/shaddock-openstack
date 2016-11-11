FROM shaddock/seed:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

#install nova
RUN pacman -S --noconfirm sysfsutils qemu libguestfs-tools neutron-linuxbridge-agent

#Setup supervisord
ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/nova"]

ADD nova-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/nova-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 8775

CMD ["nova-start"]
