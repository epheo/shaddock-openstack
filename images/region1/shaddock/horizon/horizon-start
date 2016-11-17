#!/bin/bash

HORIZON_DIR='/opt/openstack/services/horizon'

ln -s \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py.example \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py

cd $HORIZON_DIR
source bin/activate
./manage.py make_web_conf --wsgi
./manage.py make_web_conf --apache > /etc/httpd/conf/horizon.conf
deactivate

chown -R http.http /opt/openstack/services/horizon/

## The followong two lines are currently unused
sed -i '/LoadModule\ foo_module/a LoadModule\ wsgi_module\ modules/mod_wsgi.so' \
  /etc/httpd/conf/httpd.conf
cat /etc/httpd/conf/horizon.conf >> /etc/httpd/conf/httpd.conf

echo "Updating local_settings.py file..."

sed -i "s/^OPENSTACK_HOST.*/OPENSTACK_HOST = \"${KEYSTONE_API_IP}\"/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py

sed -i "s/^ALLOWED_HOSTS.*/ALLOWED_HOSTS = \[\'\*\'\]/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py

sed -i "s/^OPENSTACK_KEYSTONE_URL.*/OPENSTACK_KEYSTONE_URL = \"http:\/\/%s:5000\/v3\" % OPENSTACK_HOST/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py

sed -i "s/^#OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT.*/OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True/g" \
  $HORIZON_DIR/openstack_dashboard/local/local_settings.py

sed -i "s/^#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN.*/OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'default'/g" \
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

echo "Starting horizon using supervisord..."
exec /usr/bin/supervisord -n
