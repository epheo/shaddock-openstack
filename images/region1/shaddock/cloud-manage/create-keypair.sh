#!/bin/bash

echo "Creating Keypair ..."

source /opt/openstack/service.osrc

/opt/openstack/services/python-openstackclient/bin/openstack keypair \
  create --public-key ~/.ssh/id_rsa.pub mykeypair
