FROM archlinux:latest
MAINTAINER epheo <shaddock@epheo.eu>

# Base Archlinux docker image is outdated crap
# We should do a Jenkins job to autobuild and propose dailybuilds.
#

ENV http_proxy  http://10.154.61.3:3128
ENV https_proxy http://10.154.61.3:3128

RUN pacman -Syu --noconfirm python2-virtualenv git

RUN mkdir /opt/openstack/
WORKDIR   /opt/openstack/

ADD builder.sh ./

ENTRYPOINT ["/bin/bash","builder.sh"]
