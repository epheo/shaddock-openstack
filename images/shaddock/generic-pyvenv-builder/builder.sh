#!/usr/bin/env bash
# clone 
# activate
# install

git clone $GIT_URL
cd  `echo $GIT_URL           \
     | sed -e 's/\/$//'      \
     | awk -F/ '{print $NF}' \
     | sed -e 's/.git$//'    \
    `
if [ ! -d "venv" ]; then virtualenv venv; fi
. venv/bin/activate
pip install .
