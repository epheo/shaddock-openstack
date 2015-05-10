FROM shaddock/seed:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

# Install Keystone
RUN apt-get install -y gcc python-pip python-dev libxml2-dev libxslt-dev\
                       libffi-dev libmysqlclient-dev libpq-dev\
                       python-openssl mysql-client python-mysqldb

ADD keystone-start /usr/local/bin/
ADD configparse.py /usr/local/bin/
RUN chmod +x /usr/local/bin/keystone-start

EXPOSE 8082
