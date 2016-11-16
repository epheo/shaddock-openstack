FROM shaddock/seed:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

# Install nova compute
RUN apt-get -y install apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo" \
         "ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

# Install Docker
RUN \
     apt-get -y update &&\
     apt-get install -y docker-engine

# Install Nova compute
RUN apt-get install -y nova-compute neutron-linuxbridge-agent

# Install Driver nova docker
RUN git clone -b stable/mitaka https://github.com/openstack/nova-docker.git /opt/nova-docker
RUN cd /opt/nova-docker && pip install --upgrade -r requirements.txt && python setup.py install

# Add rootwrap filters Docker in nova
RUN cp /opt/nova-docker/etc/nova/rootwrap.d/docker.filters /etc/nova/rootwrap.d/

RUN /usr/sbin/usermod -aG docker nova

#Setup supervisord
ADD supervisord.conf /etc/supervisord.conf

VOLUME  ["/var/log/nova"]

ADD nova-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/nova-start
RUN chmod +x /usr/local/bin/configparse.py

EXPOSE 8775

CMD ["nova-start"]
