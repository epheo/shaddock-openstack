FROM panama/base:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

RUN apt-get install -y python-keystone

ADD cloud-config /usr/local/bin/
RUN chmod +x /usr/local/bin/cloud-config

CMD ["cloud-config"]
