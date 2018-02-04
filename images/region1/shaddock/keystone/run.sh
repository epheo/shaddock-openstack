#!/bin/bash

sleep 5 # for mysql to come up after being reachable

CONSTRAINTS=/opt/openstack/services/keystone/upper-constraints.txt

mkdir /etc/keystone; cp -r /opt/openstack/services/keystone/etc/* /etc/keystone/
mv /etc/keystone/keystone.conf.sample /etc/keystone/keystone.conf
mkdir -p /etc/keystone/fernet-keys/

pip install -c $CONSTRAINTS pymysql

crudini --set /etc/keystone/keystone.conf database connection \
  "mysql+pymysql://keystone:$KEYSTONE_DB_PASS@$MYSQL_VIP/keystone"
crudini --set /etc/keystone/keystone.conf token provider fernet 


echo "# Creating database..."
echo "=> Creating ${SERVICE} database"
echo "=> DB ${MYSQL_VIP}"
echo "=> User ${MYSQL_USER}"
echo "=> Password ${MYSQL_PASS}"

mysql  -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
    -e "CREATE DATABASE keystone;"

mysql  -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
    -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
        IDENTIFIED BY '${KEYSTONE_DB_PASS}';"

mysql  -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
    -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
        IDENTIFIED BY '${KEYSTONE_DB_PASS}'"

echo "# Updating database tables"
keystone-manage db_sync 

echo "# Initializing Fernet keys"
keystone-manage fernet_setup \
  --keystone-user root \
  --keystone-group root

keystone-manage credential_setup \
  --keystone-user root \
  --keystone-group root

echo "# Bootstraping Keystone with:"
echo "Password = ${ADMIN_PASS}"
echo "Endpoint = ${KEYSTONE_VIP}"

keystone-manage bootstrap \
    --bootstrap-password ${ADMIN_PASS} \
    --bootstrap-admin-url http://${KEYSTONE_VIP}:35357/v3/ \
    --bootstrap-internal-url http://${KEYSTONE_VIP}:5000/v3/ \
    --bootstrap-public-url http://${KEYSTONE_VIP}:5000/v3/ \
    --bootstrap-region-id RegionOne

echo "[done]"
