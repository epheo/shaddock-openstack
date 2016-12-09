#!/bin/bash

NOVA_PATH=/opt/openstack/services/nova
mkdir $NOVA_PATH/lib/python2.7/site-packages/instances

ln -s $NOVA_PATH/etc/nova /etc/nova

echo "Updating conf file..."
$NOVA_PATH/bin/python /opt/configparse.py

echo "Add kvm group"
chown root:kvm /dev/kvm

echo "Starting nova using supervisord..."
exec /usr/bin/supervisord -n
