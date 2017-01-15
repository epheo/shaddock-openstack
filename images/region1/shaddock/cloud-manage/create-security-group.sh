#!/bin/bash

echo "Creating Keypair ..."

source /opt/openstack/service.osrc

/opt/openstack/services/python-openstackclient/bin/openstack security group \
  rule create --proto icmp default
/opt/openstack/services/python-openstackclient/bin/openstack security group \
  rule create --proto tcp --dst-port 22 default
