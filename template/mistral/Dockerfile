FROM panama/base:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

# Install Keystone
RUN \
     apt-get update &&\
     apt-get install -y python-dev python-setuptools libffi-dev libxslt1-dev\
                        libxml2-dev libyaml-dev libssl-dev git

RUN \
     git clone https://github.com/stackforge/mistral.git &&\
     cd mistral && python setup.py install

ADD mistral-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/keystone-start

EXPOSE 8082