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

