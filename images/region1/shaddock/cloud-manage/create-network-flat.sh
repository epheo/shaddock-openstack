#!/bin/bash

echo "Creating Nova flavor..."

source /opt/openstack/service.osrc

/opt/openstack/services/python-novaclient/bin/nova network-create \
  flat-net --bridge br100 --multi-host T --fixed-range-v4 192.168.2.0/24
