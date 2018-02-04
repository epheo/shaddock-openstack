#!/bin/bash
mkdir -p /opt/openstack/osrc/
cat <<EOF > /opt/openstack/osrc/service.osrc
#!/usr/bin/env bash
export OS_USERNAME=admin
export OS_PASSWORD=${ADMIN_PASS}
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://${KEYSTONE_VIP}:35357/v3
export OS_IDENTITY_API_VERSION=3
EOF
