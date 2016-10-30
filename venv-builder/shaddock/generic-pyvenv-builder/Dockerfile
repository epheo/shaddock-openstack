FROM archlinux:latest
MAINTAINER epheo <shaddock@epheo.eu>

ENV http_proxy=http://10.154.61.3:3128 
ENV https_proxy=http://10.154.61.3:3128 

RUN pacman -Syu --noconfirm python2-virtualenv git libffi gcc libpqxx

RUN mkdir /opt/openstack/

ADD builder.sh ./

ENTRYPOINT ["/bin/bash","builder.sh","/opt/openstack"]
