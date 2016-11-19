#!/bin/bash

CINDER_PATH=/opt/openstack/services/cinder/bin/

echo "Updating conf file..."
$CINDER_PATH/python /opt/configparse.py

echo "Starting cinder using supervisord..."
exec /usr/bin/supervisord -n
