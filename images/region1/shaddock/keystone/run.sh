#!/bin/bash

KEYSTONE_PATH=/opt/openstack/services/keystone/bin/

ln -s /opt/openstack/services/keystone/etc/ /etc/keystone
mv /etc/keystone/keystone.conf.sample /etc/keystone/keystone.conf

$KEYSTONE_PATH/python /opt/configparse.py

echo "# Creating database..."
echo "=> Creating ${SERVICE} database"
echo "=> DB ${MYSQL_HOST_IP}"
echo "=> User ${MYSQL_USER}"
echo "=> Password ${MYSQL_PASSWORD}"

mysql \
    -h${MYSQL_HOST_IP} \
    -u${MYSQL_USER} \
    -p${MYSQL_PASSWORD} \
    -e "CREATE DATABASE keystone;"

mysql \
    -h${MYSQL_HOST_IP} \
    -u${MYSQL_USER} \
    -p${MYSQL_PASSWORD} \
    -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
        IDENTIFIED BY '${KEYSTONE_DBPASS}';"

mysql \
    -h${MYSQL_HOST_IP} \
    -u${MYSQL_USER} \
    -p${MYSQL_PASSWORD} \
    -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
        IDENTIFIED BY '${KEYSTONE_DBPASS}'"

echo "# Updating database tables"
/opt/openstack/services/keystone/bin/keystone-manage db_sync

echo "# Initializing Fernet keys"
/opt/openstack/services/keystone/bin/keystone-manage \
  fernet_setup \
  --keystone-user http \
  --keystone-group http

/opt/openstack/services/keystone/bin/keystone-manage \
  credential_setup \
  --keystone-user http \
  --keystone-group http

echo "# Bootstraping Keystone with:"
echo "Password = ${ADMIN_TOKEN}"
echo "Endpoint = ${KEYSTONE_API_IP}"

/opt/openstack/services/keystone/bin/keystone-manage bootstrap \
  --bootstrap-password ${ADMIN_TOKEN} \
  --bootstrap-admin-url http://${KEYSTONE_API_IP}:35357/v3/ \
  --bootstrap-internal-url http://${KEYSTONE_API_IP}:35357/v3/ \
  --bootstrap-public-url http://${KEYSTONE_API_IP}:5000/v3/ \
  --bootstrap-region-id RegionOne

echo "[done]"
echo "# Starting keystone..."
exec /usr/sbin/apachectl -D "FOREGROUND" -f /etc/httpd/wsgi-keystone.conf
