#!/bin/bash

CINDER_PATH=/opt/openstack/services/cinder/bin/

ln -s /opt/openstack/services/cinder/etc/cinder /etc/cinder

echo "Updating conf file..."
$CINDER_PATH/python /opt/configparse.py

echo "Starting cinder using supervisord..."
exec /usr/bin/supervisord -n
