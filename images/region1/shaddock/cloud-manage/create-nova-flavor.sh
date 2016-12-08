#!/bin/bash

echo "Creating Nova flavor..."

source /opt/openstack/service.osrc

/opt/openstack/services/python-novaclient/bin/nova flavor-create \
  --is-public True shdk.small auto 1024 10 2
