#!/bin/bash

echo "#!/usr/bin/env bash" > /opt/openstack/service.osrc

echo "export OS_PROJECT_DOMAIN_NAME=default" >> /opt/openstack/service.osrc
echo "export OS_USER_DOMAIN_NAME=default" >> /opt/openstack/service.osrc
echo "export OS_PROJECT_NAME=admin" >> /opt/openstack/service.osrc
echo "export OS_USERNAME=admin" >> /opt/openstack/service.osrc
echo "export OS_PASSWORD=${ADMIN_PASS}" >> /opt/openstack/service.osrc
echo "export OS_AUTH_URL=http://${KEYSTONE_API_IP}:35357/v3" >> \
  /opt/openstack/service.osrc
echo "export OS_IDENTITY_API_VERSION=3" >> /opt/openstack/service.osrc
echo "export OS_IMAGE_API_VERSION=2" >> /opt/openstack/service.osrc
