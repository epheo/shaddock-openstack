FROM ubuntu:14.04
MAINTAINER Thibaut Lapierre <root@epheo.eu>

ENV https_proxy https://172.16.1.5:8080/
RUN echo 'Acquire::http::Proxy "http://172.16.1.5:8080/";' > /etc/apt/apt.conf.d/01proxies
RUN echo 'Acquire::https::Proxy "https://172.16.1.5:8080/";' >> /etc/apt/apt.conf.d/01proxies
RUN echo 'Acquire::http::Proxy::keg.dev.uswest.hpcloud.net DIRECT;' >> /etc/apt/apt.conf.d/01proxies


# OpenStack Repo and packages
RUN apt-get -y update

RUN apt-get -y install ubuntu-cloud-keyring
RUN echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/juno main" > /etc/apt/sources.list.d/cloudarchive-juno.list

RUN \
     apt-get -y update && apt-get -y dist-upgrade &&\
     apt-get -y install supervisor wget python-pip \
                        mysql-client mysql-common \
                        python-mysqldb git python-dev \
                        libffi-dev libssl-dev \
                        python-keystoneclient \
                        python-openstackclient

ADD cloud-config /usr/local/bin/
RUN chmod +x /usr/local/bin/cloud-config

CMD ["cloud-config"]
