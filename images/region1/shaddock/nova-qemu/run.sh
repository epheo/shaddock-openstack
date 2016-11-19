#!/bin/bash

NOVA_PATH=/opt/openstack/services/nova/

ln -s $NOVA_PATH/etc/nova /etc/nova
cp /etc/nova/nova.conf.sample /etc/nova/nova.conf

echo "Updating conf file..."
$NOVA_PATH/bin/python /opt/configparse.py

echo "Add kvm group"
chown root:kvm /dev/kvm

echo "Starting nova using supervisord..."
exec /usr/bin/supervisord -n
