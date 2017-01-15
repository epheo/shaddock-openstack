#!/bin/bash

echo "Creating Nova flavor..."

source /opt/openstack/service.osrc

/opt/openstack/services/python-novaclient/bin/nova flavor-create \
  --is-public True shdk.tiny 1 512 1 1
/opt/openstack/services/python-novaclient/bin/nova flavor-create \
  --is-public True shdk.small 2 1024 10 1
