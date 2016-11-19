#!/bin/bash

echo "Updating conf file..."
NOVA_PATH=/opt/openstack/services/nova/
$NOVA_PATH/bin/python /opt/configparse.py

echo "Add kvm group"
chown root:kvm /dev/kvm

echo "Starting nova using supervisord..."
exec /usr/bin/supervisord -n
