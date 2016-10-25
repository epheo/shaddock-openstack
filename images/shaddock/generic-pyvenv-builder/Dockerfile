FROM shaddock/seed:latest
MAINTAINER epheo <shaddock@epheo.eu>


WORKDIR /opt/openstack/
RUN git clone $GIT_URL

WORKDIR `echo $GIT_URL \
         | sed -e 's/\/$//' \
         | awk -F/ '{print $NF}' \
         | sed -e 's/.git$//' \
        `

RUN if [ ! -d "venv" ]; then; virtualenv venv; fi
RUN . venv/bin/activate

RUN pip install .
