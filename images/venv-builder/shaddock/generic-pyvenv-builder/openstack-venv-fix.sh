#!/bin/bash

cd /opt/openstack/services/keystone/
source bin/activate
echo "In keystone venv"
pip install kombu==3.0.33
pip install mysql
deactivate

cd /opt/openstack/services/nova/
source bin/activate
echo "In Nova venv"
pip install vine
deactivate

cd /opt/openstack/services/glance/
source bin/activate
echo "In Glance venv"
pip install vine
deactivate

cd /opt/openstack/services/horizon/
source bin/activate
echo "In Horizon venv"
pip install -c http://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt?h=stable/newton .
./manage.py make_web_conf --wsgi
./manage.py make_web_conf --apache > /etc/httpd/conf/horizon.conf
./manage.py collectstatic
./manage.py compress
deactivate


