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
pip install kombu==3.0.33
pip install vine
pip install oslo_concurrency
deactivate

cd /opt/openstack/services/glance/
source bin/activate
echo "In Glance venv"
pip install vine
deactivate

cd /opt/openstack/services/cinder/
source bin/activate
echo "In Cinder venv"
pip install kombu==3.0.33
pip install vine
deactivate

cd /opt/openstack/services/horizon/
source bin/activate
echo "In Horizon venv"
pip install .
python manage.py make_web_conf --wsgi --force
python manage.py collectstatic --noinput
python manage.py compress
deactivate
