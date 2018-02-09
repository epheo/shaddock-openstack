#!/bin/bash

HORIZON_DIR='/opt/openstack/services/horizon'

cp $HORIZON_DIR/openstack_dashboard/local/local_settings.py.example \
   $HORIZON_DIR/openstack_dashboard/local/local_settings.py

echo "Updating local_settings.py file..."
sed -i "s/^OPENSTACK_HOST.*/OPENSTACK_HOST = \"${KEYSTONE_VIP}\"/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i "s/^#ALLOWED_HOSTS.*/ALLOWED_HOSTS = \[\'\*\'\]/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i "s/^OPENSTACK_KEYSTONE_URL.*/OPENSTACK_KEYSTONE_URL = \"http:\/\/%s:5000\/v3\" % OPENSTACK_HOST/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i "s/^#OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT.*/OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i "s/^#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN.*/OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'default'/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i "s/^#OPENSTACK_KEYSTONE_DEFAULT_ROLE.*/OPENSTACK_KEYSTONE_DEFAULT_ROLE = 'user'/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i "s/^#OPENSTACK_API_VERSIONS.*/OPENSTACK_API_VERSIONS = {/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i '/OPENSTACK_API_VERSIONS/a }' \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i '/OPENSTACK_API_VERSIONS/a     "image": 2,' \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i '/OPENSTACK_API_VERSIONS/a     "volume": 2,' \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i '/OPENSTACK_API_VERSIONS/a     "identity": 3,' \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py
sed -i "s/^#COMPRESS_ENABLED.*/COMPRESS_ENABLED = True/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py

$HORIZON_DIR/manage.py collectstatic
$HORIZON_DIR/manage.py compress --force

$HORIZON_DIR/manage.py make_web_conf --wsgi --force
$HORIZON_DIR/manage.py make_web_conf --apache --force \
  > /etc/httpd/conf/horizon.conf

chown -R http.http /opt/openstack/services/horizon/
