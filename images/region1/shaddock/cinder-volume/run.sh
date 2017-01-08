#!/bin/bash

CINDER_PATH=/opt/openstack/services/cinder/bin/

ln -s /opt/openstack/services/cinder/etc/cinder /etc/cinder

sed -i "s/udev_sync = 1/udev_sync = 0/g" \
  /etc/lvm/lvm.conf
sed -i "s/udev_rules = 1/udev_rules = 0/g" \
  /etc/lvm/lvm.conf

echo "Updating conf file..."
$CINDER_PATH/python /opt/configparse.py

echo "Starting cinder using supervisord..."
exec /usr/bin/supervisord -n
