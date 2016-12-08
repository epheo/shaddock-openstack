#!/bin/bash

echo "Creating Cirros image..."

source /opt/openstack/service.osrc

wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

/opt/openstack/services/python-glanceclient/bin/glance image-create \
  --name cirros --disk-format qcow2 --container-format \
  bare --file cirros-0.3.4-x86_64-disk.img --progress --visibility public
