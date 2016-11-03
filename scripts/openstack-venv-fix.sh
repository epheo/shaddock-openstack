#!/bin/bash

cd /opt/openstack/services/keystone/
source bin/activate
pip install kombu==3.0.33
pip install mysql
deactivate

cd /opt/openstack/services/nova/
source bin/activate
pip install vine
deactivate
